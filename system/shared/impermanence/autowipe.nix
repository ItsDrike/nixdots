{ config, lib, ... }: let
  inherit (lib) mkIf concatStringsSep flatten mapAttrsToList;
  cfg = config.myOptions.system.impermanence.autoWipeBtrfs;
in
{
  config = mkIf cfg.enable {
    boot.initrd.systemd = {
      enable = true; # This enables systemd support in stage 1 - required for below setup

      services.rollback = {
        description = "Rollback BTRFS subvolumes to a pristine state";
        enable = true;
        wantedBy = [ "initrd.target" ];
        # Make sure it's done after decryption (i.e. LUKS/TPM process)
        after = [ "systemd-cryptsetup@cryptfs.service" ];
        # mount the root fs before clearing
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = let
          # TODO: Consider adding support for moving the subvolume to something like old-roots
          #      instead of deleting it. This would allow for easier recovery in case of a mistake.
          # The subvolume can live here for a certain amount of time, before it's deleted, or there
          # can be a certain amount of total roots kept. See the example configuration here:
          # <https://github.com/nix-community/impermanence> which demonstrates keepping 30 days
          # worth of old roots.
          wipeScript = devicePath: subvolumes: ''
            # Mount the BTRFS device root to a temporary mount point
            echo "Mounting BTRFS root from ${devicePath} to /mnt"
            mount --mkdir "${devicePath}" /mnt

            # Recreate each specified subvolume
            ${concatStringsSep "\n" (map (subvolume: ''
              delete_subvolume_recursively "/mnt/${subvolume}"
              btrfs subvolume create "/mnt/${subvolume}"
            '') subvolumes)}

            # Cleanup: unmount the device
            echo "Unmounting BTRFS root from ${devicePath}"
            umount /mnt
          '';
        in ''
          # Simply deleting a subvolume with btrfs subvolume delete will not work,
          # if that subvolume contains other btrfs subvolumes. Because of that, we
          # instead use this function to delete subvolumes, whihc will first perform
          # a recursive deletion of any nested subvolumes.
          #
          # This is necessary, because the root subvolume will actually usually contain
          # other subvolumes, even if the user haven't created those explicitly. It seems
          # that NixOS creates these automatically. Namely, I observed these in root subvol:
          # - root/srv
          # - root/var/lib/portables
          # - root/var/lib/machines
          # - root/var/tmp
          delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
              delete_subvolume_recursively "/mnt/$i"
            done

            echo "Deleting subvolume $1"
            btrfs subvolume delete "$1"
          }

          ${concatStringsSep "\n" (mapAttrsToList (devicePath: deviceOpts:
            wipeScript devicePath deviceOpts.subvolumes
          ) cfg.devices)}
        '';
      };
    };
  };
}

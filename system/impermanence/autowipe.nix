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

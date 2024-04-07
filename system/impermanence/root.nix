{ config }: let
  cfgSystem = config.myOptions.system;
  cfg = config.myOptions.system.impermanence.root;
in
{
  config = mkIf cfg.enable {
    users = {
      # This option makes it that users are not mutable outside of our configuration.
      # If you're using root impermanence, this will actually be the case regardless
      # of this setting, however, setting this explicitly is a good idea, because nix
      # will warn us if our users don't have passwords set, preventing lock outs.
      mutableUsers = false;

      # Each existing user needs to have a password file defined here, otherwise
      # they will not be available to login. These password files can be generated with:
      # mkpasswd -m sha-512 > /persist/passwords/myuser
      users = {
        root = {
          hashedPasswordFile = "${cfg.persistentMountPoint}/passwords/root";
        };
        ${cfgSystem.username} = {
          hashedPasswordFile = "${cfg.persistentMountPoint}/passwords/${cfgSystem.username}";
        };
      };
    };

    environment.persistence."${cfg.persistentMountPoint}/system" = {
      hideMounts = true;
      directories = [
        "/etc/nixos" # NixOS configuration source
        "/etc/NetworkManager/system-connections" # saved network connections
        "/var/db/sudo" # keeps track of who got the sudo lecture already
        "/var/lib/systemd/coredump" # captured coredumps 
      ] ++ cfg.extraDirectories;

      files = [
        "/etc/machine-id"
      ] ++ cfg.extraFiles;
    };

    # For some reason, NetworkManager needs this instead of the impermanence mode
    # to not get screwed up
    systemd.tmpfiles.rules = [
      "L /var/lib/NetworkManager/secret_key - - - - ${cfg.persistentMountPoint}/system/var/lib/NetworkManager/secret_key"
      "L /var/lib/NetworkManager/seen-bssids - - - - ${cfg.persistentMountPoint}/system/var/lib/NetworkManager/seen-bssids"
      "L /var/lib/NetworkManager/timestamps - - - - ${cfg.persistentMountPoint}/system/var/lib/NetworkManager/timestamps"
    ];

    # Define host key paths in the persistent mount point instead of using impermanence for these.
    # This works better, because these keys also get auto-created if they don't already exist.
    services.openssh.hostKeys = mkForce [
      {
        bits = 4096;
        path = "${cfg.persistentMountPoint}/system/etc/ssh/ssh_host_rsa_key";
        type = "rsa";
      }
      {
        bits = 4096;
        path = "${cfg.persistentMountPoint}/system/etc/ssh/ssh_host_ed25519_key";
        type = "ed25519";
      }
    ];

    boot.initrd.systemd = let
      cfgWipe = cfg.autoBtrfsWipe;
    in {
      enable = true; # This enables systemd support in stage 1 - required for below setup
      services.rollback-root = {
        description = "Rollback BTRFS root subvolume to a pristine state";
        enable = cfgWipe.enable;
        wantedby = [ "initrd.target" ];
        # Make sure it's done after decryption (i.e. LUKS/TPM process)
        after = [ "systemd-cryptsetup@cryptfs.service" ];
        # mount the root fs before clearing
        before = [ "sysroot.mount" ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          # Mount the BTRFS root to /mnt, so we can manipulate the subvolumes
          mount --mkdir ${cfgWipe.devicePath} /mnt
          
          # To restore the root subvolume, we will first delete it, and then create
          # a new snapshot from the blank snapshot, which will become our new root subvolume

          # However, at this point, root subvol is already populated and contains a number
          # of subvolumes, which would make `btrfs subvolume delete` fail.
          #
          # These existing subvolumes get created automatically, and we can safely remove
          # them. They are: /srv, /var/lib/portables, /var/lib/machines, /var/tmp
          sudo btrfs subvolume list -o "/mnt/${cfgWipe.subvolumePath}" | cut -f9 -d' ' |
            while read subvolme; do
              echo "deleting $subvolume subvolume..." &&
              btrfs subvolume delete "/mnt/$subvolume"
            done

          # Now we can remove the root subvolume, and restore it from a snapshot
          echo "deleting ${cfgWipe.subvolumePath} (root) subvolume..."
          btrfs subvolume delete "/mnt/${cfg.subvolumePath}"
          echo "restoring ${cfgWipe.subvolumePath} (root) subvolume..."
          btrfs subvolume snapshot "/mnt/${cfgWipe.cleanSnapshotPath}"
          "/mnt/${cfgWipe.subvolumePath}"

          # Once we're done rolling back to a blank snapshot,
          # we can unmount /mnt and continue on the boot process
          umount /mnt
        '';
      };
    };
  };
}

{ lib, config, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption literalExpression;

  cfg = config.myOptions.system.impermanence;
in
{
  options.myOptions.system.impermanence = {
    root = {
      enable = mkEnableOption ''
        the Impermanence module for persisting important state directories.
      '';

      extraFiles = mkOption {
        default = [];
        example = literalExpression ''["/etc/nix/id_rsa"]'';
        description = ''
          Additional files in root to link to persistent storage.
        '';
      };

      extraDirectories = mkOption {
        default = [];
        example = literalExpression ''["/etc/nix/id_rsa"]'';
        description = ''
          Additional directories in root to link to persistent storage.
        '';
      };

      persistentMountPoint = mkOption {
        default = "/persist";
        description = ''
          Path to a persistent directory (usually a mount point to a
          standalone partition / subvolume), which will hold the persistent
          system state files.
        '';
      };

      autoBtrfsWipe = {
        enable = mkOption {
          default = true;
          description = ''
            Enable automatic wiping of the root BTRFS subvolume from initrd.

            Generally, you will want to keep this enabled, as otherwise setting up
            impermanence is pointless. However in case you're using a non-BTRFS
            system, or you wish to set up a custom handling for this auto-wiping,
            which the current handling doesn't support, disable this.
          '';
        };

        devicePath = mkOption {
          default = "/dev/mapper/cryptfs";
          description = ''
            Path to the BTRFS block device containing the subvolume to be wiped.

            This device will be mounted from initrd.
          '';
        };

        subvolumePath = mkOption {
          default = "root";
          description = ''
            Path to the BTRFS subvolume to be wiped.

            This is a relative path, starting from the BTRFS root.
          '';
        };

        cleanSnapshotPath = mkOption {
          default = "root-blank";
          description = ''
            Path to the BTRFS snapshot (subvolume) to be restore 
            `myOptions.system.impermanence.root.autoWipe.btrfsSubvolume` to.

            This should be a blank snapshot to achieve a complete wipe.
          '';
        };
      };
    };
  };
}

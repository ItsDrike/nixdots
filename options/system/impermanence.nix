{ lib, config, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption literalExpression types;

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
        type = types.listOf types.path;
        example = literalExpression ''["/etc/nix/id_rsa"]'';
        description = ''
          Additional files in root to link to persistent storage.
        '';
      };

      extraDirectories = mkOption {
        default = [];
        type = types.listOf types.path;
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

          This should point to the entire persistent partition, this setup
          then expects this directory to contain `passwords` and `system` subdirectories.
        '';
      };
    };

    home = {
      enable = mkEnableOption ''
        the Impermanence module for persisting important state directories.

        This requires home-manager.
      '';

      extraFiles = mkOption {
        default = [];
        type = types.listOf types.str;
        example = literalExpression ''[".zshrc"]'';
        description = ''
          Additional files in home to link to persistent storage.
        '';
      };

      extraDirectories = mkOption {
        default = [];
        type = types.listOf types.str;
        example = literalExpression ''[".config/chromium"]'';
        description = ''
          Additional directories in home to link to persistent storage.
        '';
      };

      persistentMountPoint = mkOption {
        default = "/persist/home";
        description = ''
          Path to a persistent directory (usually a mount point to a
          standalone partition or subvolume), which will hold the persistent
          system state files.

          This does not create any subdirectories, all of the persistent home files
          will be put directly in here. The user should be the owner of this direcotry.
        '';
      };

      persistentDataMountPoint = mkOption {
        default = "/persist/home";
        description = ''
          Path to a persistent directory (usually a mount point to a
          standalone partition or subvolume), which will hold the persistent
          data files.

          This does not create any subdirectories, all of the persistent home files
          fill be put directly in here. The user should be the owner of this directory.

          If you don't wish to distinguish between data and system / configuration files, 
          you can point this to the same location.
        '';
      };

      extraDataFiles = mkOption {
        default = [];
        type = types.listOf types.str;
        example = literalExpression ''["notes.txt"]'';
        description = ''
          Additional files in home to link to persistent data storage.
        '';
      };

      extraDataDirectories = mkOption {
        default = [];
        type = types.listOf types.str;
        example = literalExpression ''["Downloads"]'';
        description = ''
          Additional directories in home to link to persistent data storage.
        '';
      };
    };

    autoWipeBtrfs = let
      btrfsDeviceOptionType = types.submodule {
        options = {
          subvolumes = mkOption {
            type = types.listOf types.str;
            default = [];
            description = ''
              List of BTRFS subvolumes to be wiped from the device.

              These subvolumes will be wiped from initrd, before the subvolumes are mounted.
            '';
            example = literalExpression ''[ "root" "home" ]'';
          };
        };
      };
    in {
      enable = mkEnableOption ''
          automatic wiping of specified BTRFS subvolumes from initrd.

          If you're using BTRFS, you will generally want to enable this, however
          with a non-BTRFS system, or in case you wish to set up some custom handling
          which this module doesn't support, you will need to write your own logic
          for automatic root wiping.

          One option is is to simply have your root get mounted from tmpfs, making it 
          live in RAM. This does however require dedicating a concrete chunk of RAM.
        '';

      devices = mkOption {
        default = {};
        type = types.attrsOf btrfsDeviceOptionType;
        description = ''
          BTRFS devices and their subvolumes to be wiped.
        '';
        example = literalExpression ''
          {
            "/dev/sda1" = {
              subvolumes = [ "root" ];
            };
            "/dev/mapper/cryptfs" = {
              subvolumes = [ "homeJohn" "homeBob" ];
            };
          }
        '';
      };
    };
  };

  config = {
    assertions = [
      {
        assertion = cfg.autoWipeBtrfs.enable -> cfg.root.enable;
        message = "myOptions.system.impermanence.autoWipeBtrfs requires myOptions.system.impermanence.root to be enabled.";
      }
    ];
  };
}

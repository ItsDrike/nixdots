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
}

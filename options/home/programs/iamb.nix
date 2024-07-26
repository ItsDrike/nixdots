{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types mkIf;

  cfg = config.myOptions.home-manager.programs.applications.iamb;
in {
  options.myOptions.home-manager.programs.applications.iamb = {
    enable = mkEnableOption "iamb (vim-inspired terminal Matrix client)";
    defaultProfile = mkOption {
      type = types.str;
      default = "default";
      description = "Default profile to be used when the app starts";
    };
    profiles = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          userId = mkOption {
            type = types.str;
            example = "@itsdrike:envs.net";
            description = "Your Matrix user ID";
          };
          homeServer = mkOption {
            type = types.nullOr types.str;
            example = "https://matrix.envs.net";
            default = null;
            description = ''
              If your homeserver is located on a different domain than the server part
              of the `userId`, then you can explicitly specify a homeserver URL to use.
            '';
          };
        };
      });
      default = {};
      description = "Profiles for the iamb client, keyed by profile name";
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = builtins.elem cfg.defaultProfile (lib.attrNames cfg.profiles);
        message = "Default profile must be present in profiles configuration";
      }
    ];
  };
}

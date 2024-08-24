{lib, ...}: let
  inherit (lib) mkOption mkEnableOption types;
in {
  imports = [
    ./boot
    ./impermanence.nix
  ];

  options.myOptions.system = {
    hostname = mkOption {
      type = types.str;
      description = "Hostname for this system";
    };

    username = mkOption {
      type = types.str;
      description = "Username for the primary admin account for this system";
    };

    sound = {
      enable = mkEnableOption "sound related programs and audio-dependent programs";
    };

    docker = {
      enable = mkEnableOption "docker virtualisation platform";
      data-root = mkOption {
        type = types.str;
        description = "Path to the directory where docker data should be stored";
        default = "/var/lib/docker";
      };
    };
  };
}

{ lib, ... }: with lib; let
  inherit (lib) mkOption;
in
{
  imports = [
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
  };
}
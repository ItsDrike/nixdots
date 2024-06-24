{ lib, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption;
in
{
  imports = [
    ./programs
    ./git.nix
    ./wms.nix
    ./theme.nix
    ./services.nix
    ./preferences.nix
  ];

  options.myOptions.home-manager = {
    enable = mkEnableOption "home-manager";

    stateVersion = mkOption {
      type = types.str;
      default = config.system.nixos;
      description = "HomeManager's state version";
    };
  };
}


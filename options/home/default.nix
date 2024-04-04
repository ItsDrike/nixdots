{ lib, ... }: with lib; let
in
{
  imports = [
    ./git.nix
  ];

  options.myOptions.home-manager = {
    enabled = mkOption {
      type = types.bool;
      default = false;
      description = "Should home-manager be enabled for this host?";
    };

    stateVersion = mkOption {
      type = types.str;
      default = config.system.nixos;
      description = "HomeManager's state version";
    };
  };
}


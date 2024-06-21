{ lib, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.myOptions.home-manager.services = {
    dunst.enable = mkEnableOption "Dunst (lightweight notification daemon)";
  };
}


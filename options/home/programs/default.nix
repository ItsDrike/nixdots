{ lib, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.myOptions.home-manager.programs = {
    launchers = {
      wofi.enable = mkEnableOption "Wofi launcher";
      walker.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Walker launcher.";
      };
    };

    bars = {
      eww = {
        enable = mkEnableOption "Eww bar";
        autostart.enable = mkEnableOption "auto-starting eww daemon on graphical-session.target";
      };
    };

    spotify.enable = mkEnableOption "Spotify";
  };
}

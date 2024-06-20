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

    browsers = {
      chromium.enable = mkEnableOption "Chromium browser";
      firefox.enable = mkEnableOption "Firefox browser";
      mullvad-browser.enable = mkEnableOption "Mullvad browser";
      schizofox.enable = mkEnableOption "Schizophrenic version of Firefox browser";
    };

    spotify.enable = mkEnableOption "Spotify";
  };
}

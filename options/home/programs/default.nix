{ lib, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption types;
in
{
  imports = [
    ./iamb.nix
  ];

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

    applications = {
      spotify.enable = mkEnableOption "Spotify";
      stremio.enable = mkEnableOption "Stremio free media center";
      vesktop = {
        enable = mkEnableOption "Vesktop (An alternate client for Discord with Vencord built-in)";
        autoStart = mkEnableOption "Auto-Start for Vesktop";
      };
      webcord = {
        enable = mkEnableOption "Webcord (An electron-based Discord client implemented without Discord API with Vencord built-in)";
        autoStart = mkEnableOption "Auto-Start for Webcord";
      };
      nomacs.enable = mkEnableOption "Nomacs (Qt-based image viewer)";
      qimgv.enable = mkEnableOption "QImgV (Qt-based image viewer with video support)";
      qbittorrent.enable = mkEnableOption "Qbittorrent (Free software BitTorrent client)";
      obs.enable = mkEnableOption "OBS (Free and oepn source software for video recording and live streaming)";
      mpv.enable = mkEnableOption "MPV (General-purpose media player)";
      qalculate-gtk.enable = mkEnableOption "qalculate-gtk (The ultimate desktop calculator)";
    };

    file-managers = {
      pcmanfm-qt.enable = mkEnableOption "Pcmanfm-qt (extremely fast and lightweight file manager and the standard file manager of LXDE)";
    };

    tools = {
      fastfetch.enable = mkEnableOption "FastFetch (fast neofetch)";
      hyfetch.enable = mkEnableOption "Neofetch with pride flags";
    };

    coding = {
      python.enable = mkEnableOption "Python coding utilities";
    };

    games = {
      prismlauncher.enable = mkEnableOption "PrismLauncher";
    };
  };
}

{
  lib,
  pkgs,
  osConfig,
  config,
  ...
}: let
  inherit (lib) mkIf getExe;

  cfg = osConfig.myOptions.home-manager.services.hyprpaper;
  cfgIsWayland = osConfig.myOptions.home-manager.wms.isWayland;
in {
  config = mkIf (cfg.enable && cfgIsWayland) {
    systemd.user.services.hyprpaper = {
      Install.WantedBy = ["hyprland-session.target"];
      Unit = {
        Description = "Hyprpaper (Hyprland wallpaper daemon)";
        PartOf = ["graphical-session.target"];
        After = ["graphical-session.target"];
      };
      Service = {
        Type = "simple";
        ExecStart = "${getExe pkgs.hyprpaper}";
        Restart = "on-failure";
      };
    };
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload=${cfg.wallpaperPath}
      wallpaper=,${cfg.wallpaperPath} # same wallpaper on all monitors
      ipc=off
    '';
  };
}

{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfgIsWayland = osConfig.myOptions.home-manager.wms.isWayland;
in {
  config = mkIf cfgIsWayland {
    systemd.user.services."wl-clip-persist" = {
      Unit = {
        Description = "wl-clip-persist (Persist clipboard entries on wayland even after the application gets closed.)";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular --reconnect-tries 1 --selection-size-limit 1048576";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}

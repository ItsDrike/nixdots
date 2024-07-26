{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf getExe;

  cfgEnabled = config.myOptions.home-manager.wms.isWayland;
in {
  config = mkIf cfgEnabled {
    systemd.services = {
      # Seat management daemon
      # (Takes care of mediating access to shared devices (graphics, input), without requiring
      # applications like Wayland compositors being granted root privileges)
      seatd = {
        enable = true;
        description = "Seat management daemon";
        script = "${getExe pkgs.seatd} -g wheel";
        serviceConfig = {
          Type = "simple";
          Restart = "always";
          RestartSec = "1";
        };
        wantedBy = ["multi-user.target"];
      };
    };
  };
}

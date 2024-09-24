{
  pkgs,
  lib,
  ...
}: let
  inherit (lib.modules) mkForce;
  inherit (lib.strings) makeBinPath;
in {
  # allows changing system behavior based upon user-selected power profiles
  # (with `powerprofilesctl` command)
  services.power-profiles-daemon.enable = true;

  # Power state monitor. Switches power profiles based on charging state.
  # Plugged in - performance (if available, falls back to balance)
  # Unplugged - balanced, until below 50%, then power-saver
  systemd.services."power-monitor" = let
    dependencies = with pkgs; [
      coreutils
      gnugrep
      power-profiles-daemon
      inotify-tools
      jaq
    ];
  in {
    description = "Power Monitoring Service";
    environment.PATH = mkForce "/run/wrappers/bin:${makeBinPath dependencies}";
    script = builtins.readFile ./power_monitor.sh;

    serviceConfig = {
      Type = "simple";
      Restart = "on-failure";
    };

    wants = ["power-profiles-daemon.service"];
    wantedBy = ["default.target"];
  };
}

{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe;

  scriptPkgs = import ../packages/cli/scripts/packages {inherit pkgs;};
in {
  systemd.user = {
    services.gh-notify = {
      Unit = {
        Description = "Show unread GitHub notifications";
        After = ["dunst.service"];
      };
      Install.WantedBy = ["graphical-session.target"];
      Service = {
        ExecStart = "${getExe scriptPkgs.gh-notify} -vv";
        Type = "oneshot";
        RemainAfterExit = false;
        Restart = "on-failure";
        RestartSec = "3s";
      };
    };
    timers.gh-notify = {
      Unit.Description = "Timer of GitHub notification sendout";
      Timer.OnUnitActiveSec = "1m";
      Install.WantedBy = ["graphical-session.target"];
    };
  };
}

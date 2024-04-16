{ config, lib, ... }: let
  inherit (lib) mkIf;

  cfg = config.myOptions.security.auditd;
in {
  config = mkIf cfg.enable {
    security = {
      auditd.enable = true;
      audit = {
        enable = true;
        # maximum number of outstanding audit buffers allowed
        # exceeding this is considered a failure and handled in
        # a manner specified by failureMode
        backlogLimit = 8192;
        # how to handle critical errors in the auditing system
        failureMode = "printk"; # "silent" | "printk" | "panic"
        rules = [
          "-a exit,always -F arch=b64 -S execve"
        ];
      };
    };

    systemd = mkIf cfg.autoPrune.enable {
      # Systemd timer to clean /var/log/audit.log on configured schedule
      timers."clean-audit-log" = {
        description = "Periodically clean audit log";
        wantedBy = ["timers.target"];
        timerConfig = {
          OnCalendar = cfg.autoPrune.schedule;
          Persistent = true;
        };
      };

      # clean audit log if it's larger than the configured size
      services."clean-audit-log" = {
        script = ''
          set -eu
          if [[ $(stat -c "%s" /var/log/audit/audit.log) -gt ${builtins.toString cfg.autoPrune.size} ]]; then
            echo "Clearing Audit Log";
            rm -rvf /var/log/audit/audit.log;
            echo "Done!"
          fi
        '';

        serviceConfig = {
          Type = "oneshot";
          User = "root";
        };
      };
    };
  };
}

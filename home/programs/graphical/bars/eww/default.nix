{ 
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.bars.eww;
in {
  config = mkIf cfg.enable {
    programs.eww = {
      enable = true;
      configDir = ./config;
    };

    systemd.user.services = {
      "eww" = {
        Unit = {
          Description = "ElKowar's Wacky Widgets (eww) daemon";
          After = [ "graphical-session-pre.target" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "simple";
          Restart = "always";
          ExecStart = pkgs.writeShellScript "eww-daemon" ''
            ${pkgs.eww}/bin/eww daemon --no-daemonize
          '';

          # Takes a value between -20 and 19. Higher values (e.g. 19) mean lower priority.
          # Lower priority means the process will get less CPU time and therefore will be slower.
          # Fortunately, I do not need my status bar to be fast. Also, te difference is almost
          # unnoticeable and definitely negligible.
          Nice = 19;
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };

      "eww-window@" = {
        Unit = {
          Description = "Open %I eww (ElKowar's Wacky Widgets) window";
          After = [ "eww.service" ];
          PartOf = [ "graphical-session.target" ];
        };

        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStartPre = "${pkgs.eww}/bin/eww ping";
          ExecStart = "${pkgs.eww}/bin/eww open %i";
          ExecStop = "${pkgs.eww}/bin/eww close %i";
          Restart = "on-failure";
        };

        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
  };
}

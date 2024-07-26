{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  scriptPkgs = import ../../../../packages/cli/scripts/packages {inherit pkgs;};

  cfg = osConfig.myOptions.home-manager.programs.bars.eww;
in {
  config = mkIf cfg.enable {
    programs.eww = {
      enable = true;
      configDir = ./config;
    };

    systemd.user.services = {
      "eww" = let
        # All dependencies required for eww and for the scripts/widgets it uses
        dependencies = with pkgs; [
          python3
          bash
          coreutils
          findutils
          gnugrep
          gawk
          netcat-openbsd
          jq
          bc
          util-linux
          systemd
          bluez
          upower
          wl-gammarelay-rs
          gammastep
          networkmanager
          wireplumber
          pulseaudio
          hyprland
          scriptPkgs.bitcoin
        ];
      in {
        Unit = {
          Description = "ElKowar's Wacky Widgets (eww) daemon";
          After = ["graphical-session-pre.target"];
          PartOf = ["graphical-session.target"];
        };

        Service = {
          Type = "simple";
          Restart = "alwayss";
          Environment = "PATH=/run/wrappers/bin:${lib.makeBinPath dependencies}";
          ExecStart = pkgs.writeShellScript "eww-daemon" ''
            ${pkgs.eww}/bin/eww daemon --no-daemonize
          '';

          # Takes a value between -20 and 19. Higher values (e.g. 19) mean lower priority.
          # Lower priority means the process will get less CPU time and therefore will be slower.
          # Fortunately, I do not need my status bar to be fast. Also, te difference is almost
          # unnoticeable and definitely negligible.
          Nice = 19;
        };

        Install.WantedBy = ["graphical-session.target"];
      };

      "eww-window-bar0" = {
        Unit = {
          Description = "Open bar0 eww (ElKowar's Wacky Widgets) window";
          After = ["eww.service"];
          PartOf = ["graphical-session.target" "eww.service"];
        };

        Service = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStartPre = "${pkgs.eww}/bin/eww ping";
          ExecStart = "${pkgs.eww}/bin/eww open bar0";
          ExecStop = "${pkgs.eww}/bin/eww close bar0";
          Restart = "on-failure";
        };

        Install.WantedBy = ["graphical-session.target"];
      };
    };
  };
}

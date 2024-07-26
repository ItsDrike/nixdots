{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.webcord;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      # Webcord with vencord extension installed
      webcord-vencord
    ];

    systemd.user.services."webcord" = mkIf cfg.autoStart {
      Unit = {
        Description = "Webcord (An electron-based Discord client implemented without Discord API with Vencord built-in)";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.webcord-vencord}/bin/webcord";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}

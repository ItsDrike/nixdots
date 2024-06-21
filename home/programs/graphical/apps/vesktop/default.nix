{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.vesktop;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ vesktop ];

    systemd.user.services."vesktop" = mkIf cfg.autoStart {
      Unit = {
        Description = "Vesktop (An alternate client for Discord with Vencord built-in)";
        After = [ "graphical-session.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        Restart = "on-failure";
        ExecStart = "${pkgs.vesktop}/bin/vesktop";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}

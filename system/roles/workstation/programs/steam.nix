{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.myOptions.home-manager.programs.games.steam;
in {
  config = mkIf cfg.enable {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
    };
  };
}

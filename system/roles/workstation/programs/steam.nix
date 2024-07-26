{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.myOptions.home-manager.programs.games.steam;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf ((builtins.elem deviceType acceptedTypes) && cfg.enable) {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = false;
      dedicatedServer.openFirewall = false;
    };
  };
}

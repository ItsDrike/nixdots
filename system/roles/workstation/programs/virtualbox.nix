{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.myOptions.home-manager.programs.applications.virtualbox;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf ((builtins.elem deviceType acceptedTypes) && cfg.enable) {
    virtualisation.virtualbox.host = {
      enable = true;

      # Don't include the Qt dependency and GUI app,
      # if gui is desired, it can be installed separately on a per-user basis
      headless = true;
    };
  };
}

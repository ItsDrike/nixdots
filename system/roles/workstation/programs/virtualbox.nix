{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfgUser = config.myOptions.system.username;
  cfg = config.myOptions.home-manager.programs.applications.virtualbox;
in {
  config = mkIf cfg.enable {
    virtualisation.virtualbox.host = {
      enable = true;

      # Don't include the Qt dependency and GUI app,
      # if gui is desired, it can be installed separately on a per-user basis
      headless = true;
    };

    users.extraGroups.vboxusers.members = ["${cfgUser}"];
  };
}

{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfgUser = config.myOptions.system.username;
  cfg = config.myOptions.home-manager.programs.applications.wireshark;
in {
  config = mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    users.extraGroups.wireshark.members = ["${cfgUser}"];
  };
}

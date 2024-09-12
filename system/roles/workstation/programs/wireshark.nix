{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  cfgUser = config.myOptions.system.username;
  cfg = config.myOptions.home-manager.programs.applications.wireshark;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf ((builtins.elem deviceType acceptedTypes) && cfg.enable) {
    programs.wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    users.extraGroups.wireshark.members = ["${cfgUser}"];
  };
}

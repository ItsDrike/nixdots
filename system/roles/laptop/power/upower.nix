{ pkgs, lib, config, ...}: let
  inherit (lib) mkIf;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop"];
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    services = {
      # DBus service that provides power management support to applications
      upower = {
        enable = true;
        percentageLow = 15;
        percentageCritical = 5;
        percentageAction = 3;
        criticalPowerAction = "Hibernate";
      };
    };
  };
}


# This sets up power management using auto-cpufreq,
# alongside with upower and power-profiles-daemon.
# Together, this provides a complete alternative to TLP
{ pkgs, lib, config, ...}: let
  inherit (lib) mkIf mkDefault;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop"];
in {
  imports = [
    ./power-profiles-daemon
  ];

  config = mkIf (builtins.elem deviceType acceptedTypes) {
    services = {
      # superior power management
      auto-cpufreq = {
        enable = true;
        settings = let
          MHz = x: x * 1000;
        in {
          battery = {
            governor = "powersave";
            scaling_min_freq = mkDefault (MHz 1200);
            scaling_max_freq = mkDefault (MHz 1800);
            turbo = "never";
          };

          charger = {
            governor = "performance";
            scaling_min_freq = mkDefault (MHz 1800);
            scaling_max_freq = mkDefault (MHz 3800);
            turbo = "auto";
          };
        };
      };

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

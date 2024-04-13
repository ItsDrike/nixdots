{ pkgs, lib, config, ...}: let
  inherit (lib) mkIf mkDefault;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop"];
in {
  imports = [
    ./auto-cpufreq
  ];

  config = mkIf (builtins.elem deviceType acceptedTypes) {
    hardware.acpilight.enable = true;

    environment.systemPackages = with pkgs; [
      acpi
      powertop
    ];

    services = {
      # handle ACPI events
      acpid.enable = true;

      # temperature target on battery
      undervolt = {
        tempBat = 65; # deg C
        package = pkgs.undervolt;
      };
    };

    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };
  };
}

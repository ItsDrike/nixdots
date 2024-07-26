{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop"];
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    hardware.acpilight.enable = true;

    environment.systemPackages = with pkgs; [acpi];

    # handle ACPI events
    services.acpid.enable = true;

    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [
        acpi_call
        cpupower
      ];
    };
  };
}

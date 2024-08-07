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
  imports = [
    ./power-profiles-daemon
    ./upower.nix
    ./acpi.nix
    ./systemd.nix
  ];

  config = mkIf (builtins.elem deviceType acceptedTypes) {
    environment.systemPackages = with pkgs; [powertop];
  };
}

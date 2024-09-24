{pkgs, ...}: {
  imports = [
    ./power-profiles-daemon
    ./upower.nix
    ./acpi.nix
    ./systemd.nix
  ];

  config = {
    environment.systemPackages = with pkgs; [powertop];
  };
}

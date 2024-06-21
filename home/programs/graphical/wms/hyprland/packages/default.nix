{
  pkgs,
  ...
}: let
  packages = {
    hyprland-move-window = pkgs.callPackage ./hyprland-move-window {};
    brightness = pkgs.callPackage ./brightness {};
    hyprland-screenshot = pkgs.callPackage ./hyprland-screenshot {};
    quick-record = pkgs.callPackage ./quick-record {};
    toggle-fake-fullscreen = pkgs.callPackage ./toggle-fake-fullscreen {};
  };
in
  packages

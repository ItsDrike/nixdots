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
    toggle-notifications = pkgs.callPackage ./toggle-notifications {};
    toggle-idle = pkgs.callPackage ./toggle-idle {};
  };
in
  packages

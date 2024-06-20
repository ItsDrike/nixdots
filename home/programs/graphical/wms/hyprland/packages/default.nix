{
  pkgs,
  ...
}: let
  packages = {
    hyprland-move-window = pkgs.callPackage ./hyprland-move-window {};
    brightness = pkgs.callPackage ./brightness {};
  };
in
  packages

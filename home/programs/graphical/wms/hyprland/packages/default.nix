{
  pkgs,
  ...
}: let
  packages = {
    hyprland-swap-workspace = pkgs.callPackage ./hyprland-swap-workspace {};
    hyprland-move-window = pkgs.callPackage ./hyprland-move-window {};
    brightness = pkgs.callPackage ./brightness {};
  };
in
  packages

{
  pkgs,
  ...
}: let
  packages = {
    hyprland-swap-workspace = pkgs.callPackage ./hyprland-swap-workspace {};
    hyprland-move-window = pkgs.callPackage ./hyprland-move-window {};
  };
in
  packages

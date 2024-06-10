{
  pkgs,
  ...
}: let
  packages = {
    hyprland-swap-workspace = pkgs.callPackage ./hyprland-swap-workspace {};
  };
in
  packages

{
  pkgs,
  ...
}: let
  packages = {
    dbus-hyprland-env = pkgs.callPackage ./dbus-hyprland-env.nix {};
  };
in
  packages

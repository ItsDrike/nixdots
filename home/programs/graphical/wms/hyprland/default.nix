{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  hyprPkgs = (import ./packages {inherit pkgs;});

  cfg = osConfig.myOptions.home-manager.wms.hyprland;
in {
  imports = [
      ./config
  ];

  config = mkIf cfg.enable {
    home.packages = [
      hyprPkgs.hyprland-move-window
      hyprPkgs.hyprland-screenshot
      hyprPkgs.quick-record
      hyprPkgs.toggle-fake-fullscreen
      hyprPkgs.toggle-notifications
      hyprPkgs.brightness
      pkgs.brightnessctl
      pkgs.hyprpicker
    ];

    wayland.windowManager.hyprland = {
      enable = true;
      xwayland.enable = true;
      systemd = {
        enable = true;
        variables = ["--all"];
      };
    };
  };
}

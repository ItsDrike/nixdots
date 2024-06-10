{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  inherit (import ./packages {inherit pkgs;}) hyprland-swap-workspace hyprland-move-window;

  cfg = osConfig.myOptions.home-manager.wms.hyprland;
in {
  imports = [
      ./config
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hyprland-swap-workspace
      hyprland-move-window
      brightness
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

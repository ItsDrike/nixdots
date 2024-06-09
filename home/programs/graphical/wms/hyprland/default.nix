{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  inherit (import ./packages {inherit pkgs;}) dbus-hyprland-env;

  cfg = osConfig.myOptions.home-manager.wms.hyprland;
in {
  imports = [
      ./config
  ];

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dbus-hyprland-env
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

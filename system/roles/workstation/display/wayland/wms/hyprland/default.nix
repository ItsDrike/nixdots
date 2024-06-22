{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfgEnabled = config.myOptions.home-manager.wms.hyprland.enable;

  # TODO: Switch to flake
  hyprlandPkg = pkgs.hyprland;
  xdgDesktopPortalHyprlandPkg = pkgs.xdg-desktop-portal-hyprland;
in {
  config = mkIf cfgEnabled {
    services.displayManager.sessionPackages = [hyprlandPkg];

    xdg.portal = {
      enable = true;
      configPackages = [hyprlandPkg];
      extraPortals = [xdgDesktopPortalHyprlandPkg];
    };

    programs.hyprland = {
      enable = true;
      package = hyprlandPkg;
      portalPackage = xdgDesktopPortalHyprlandPkg;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfgEnabled = config.myOptions.home-manager.wms.isWayland;
  cfgHyprlandEnabled = config.myOptions.home-manager.wms.hyprland.enable;
in {
  config = mkIf cfgEnabled {
    xdg.portal = {
      enable = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
      ];

      # Specify which portals should be used by the individual interfaces
      # see: <https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in>
      config.common = let
        # Note: this assumes a wlroots based compositor if it's not hyprland
        # which may not always actually be the case, however, I can't be bothered to handle
        # everything here and I don't plan on moving WMs any time soon.
        portal =
          if cfgHyprlandEnabled
          then "hyprland"
          else "wlr";
      in {
        # Use this portal for every interface, unless a specific override is present
        default = ["gtk"];

        # Fix flameshot on hyprland / wlroots compositors
        "org.freedesktop.impl.portal.Screencast" = [portal];
        "org.freedesktop.impl.portal.Screenshot" = [portal];
      };
    };
  };
}

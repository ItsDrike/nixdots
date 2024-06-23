{pkgs, ...}: {
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    # Specify which portals should be used by the individual interfaces
    # see: <https://github.com/flatpak/xdg-desktop-portal/blob/1.18.1/doc/portals.conf.rst.in>
    config.common = {
      # Use this portal for every interface, unless a specific override is present
      default = ["gtk"];
    };
  };
}

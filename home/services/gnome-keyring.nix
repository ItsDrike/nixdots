{pkgs, ...}: {
  config = {
    services.gnome-keyring.enable = true;
    xdg.portal.config.common = {
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
    };

    # Enable seahorse (application for managing encryption keys
    # and passwords in the gnome keyring)
    home.packages = with pkgs; [ seahorse ];
  };
}

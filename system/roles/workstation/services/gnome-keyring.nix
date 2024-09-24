{pkgs, ...}: {
  services = {
    udev.packages = with pkgs; [gnome.gnome-settings-daemon];
    gnome.gnome-keyring.enable = true;
  };

  # seahorse is an application for managing encryption keys
  # and passwords in the gnome keyring
  programs.seahorse.enable = true;

  xdg.portal.config.common = {
    "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
  };
}

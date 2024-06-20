{
  osConfig,
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = osConfig.myOptions.home-manager.theme.gtk;
in {
  home = {
    packages = with pkgs; [
      glib # gsettings
      cfg.theme.package
      cfg.iconTheme.package
    ];

    sessionVariables = {
      # set GTK theme to the name specified by the gtk theme package
      GTK_THEME = "${cfg.theme.name}";

      # gtk applications should use filepickers specified by xdg
      GTK_USE_PORTAL = "${toString (if cfg.usePortal then 1 else 0)}";
    };
  };

  gtk = {
    enable = true;

    theme = {
      name = cfg.theme.name;
      package = cfg.theme.package;
    };

    iconTheme = {
      name = cfg.iconTheme.name;
      package = cfg.iconTheme.package;
    };

    font = {
      name = cfg.font.name;
      size = cfg.font.size;
    };

    gtk2 = {
      configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      extraConfig = ''
        gtk-xft-antialias=1
        gtk-xft-hinting=1
        gtk-xft-hintstyle="hintslight"
        gtk-xft-rgba="rgb"
      '';
    };

    gtk3.extraConfig = {
      gtk-toolbar-style = "GTK_TOOLBAR_BOTH";
      gtk-toolbar-icon-size = "GTK_ICON_SIZE_LARGE_TOOLBAR";
      gtk-decoration-layout = "appmenu:none";
      gtk-button-images = 1;
      gtk-menu-images = 1;
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-error-bell = 0;
      gtk-application-prefer-dark-theme = true;
    };

    gtk4.extraConfig = {
      gtk-decoration-layout = "appmenu:none";
      gtk-enable-event-sounds = 0;
      gtk-enable-input-feedback-sounds = 0;
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-error-bell = 0;
      gtk-application-prefer-dark-theme = true;
    };
  };
}

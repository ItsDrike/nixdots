{
  pkgs,
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf mkMerge;

  cfg = osConfig.myOptions.home-manager.theme.qt;
in {
  qt = {
    enable = true;
    # just an override for QT_QPA_PLATFORMTHEME, takes "gtk", "gnome", "qtct" or "kde"
    platformTheme.name =
      if cfg.forceGtk
      then "gtk"
      else "qtct";
    style = mkIf (!cfg.forceGtk) {
      # sets QT_STYLE_OVERRIDE
      name = "kvantum";
    };
  };

  home = {
    packages = with pkgs;
      mkMerge [
        [
          # QT5 & QT6 configuration tools
          libsForQt5.qt5ct
          kdePackages.qt6ct

          # Icon theme (here as fallback)
          cfg.iconTheme.package
          breeze-icons
        ]

        (mkIf cfg.forceGtk [
          # libraries to ensure that "gtk" platform theme works
          # as intended after the following PR:
          # <https://github.com/nix-community/home-manager/pull/5156>
          libsForQt5.qtstyleplugins
          qt6Packages.qt6gtk2
        ])

        (mkIf (!cfg.forceGtk) [
          # If we're not forcing GTK themes, use Kvantum.
          # Kvantum as a library and a program to theme qt applications.
          qt6Packages.qtstyleplugin-kvantum
          libsForQt5.qtstyleplugin-kvantum

          # Also add the Kvantum theme package to path
          cfg.kvantumTheme.package
        ])
      ];

    sessionVariables = {
      # scaling - 1 means no scaling
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";

      # use wayland as the default backend, fallback to xcb if wayland is not available
      QT_QPA_PLATFORM = "wayland;xcb";

      # disable window decorations everywhere
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      # remain backwards compatible with qt5
      DISABLE_QT5_COMPAT = "0";

      # tell calibre to use the dark theme, because the light one hurts my eyes
      CALIBRE_USE_DARK_PALETTE = "1";
    };
  };

  xdg.configFile = mkIf (!cfg.forceGtk) {
    # Kvantum configuration
    "Kvantum/kvantum.kvconfig" = {
      text = lib.generators.toINI {} {
        General.theme = cfg.kvantumTheme.name;
      };
    };
    "Kvantum/${cfg.kvantumTheme.name}".source = "${cfg.kvantumTheme.package}/share/Kvantum/${cfg.kvantumTheme.name}";

    # Set icon theme using qtct
    "qt5ct/qt5ct.conf".text = lib.generators.toINI {} {
      Appearance = {
        icon_theme = cfg.iconTheme.name;
      };
    };

    "qt6ct/qt6ct.conf".text = lib.generators.toINI {} {
      Appearance = {
        icon_theme = cfg.iconTheme.name;
      };
    };
  };
}

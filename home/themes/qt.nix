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
    platformTheme.name = mkIf cfg.forceGtk "gtk";  # just an override for QT_QPA_PLATFORMTHEME, takes "gtk", "gnome", "qtct" or "kde"
    style = mkIf (!cfg.forceGtk) {
      name = cfg.theme.name;
      package = cfg.theme.package;
    };
  };

  home = {
    packages = with pkgs;
      mkMerge [
        [
          # libraries and programs to ensure that qt applications load without issue
          # breeze-icons is added as a fallback
          libsForQt5.qt5ct
          kdePackages.qt6ct
          breeze-icons
        ]

        (mkIf cfg.forceGtk [
          # libraries to ensure that "gtk" platform theme works
          # as intended after the following PR:
          # <https://github.com/nix-community/home-manager/pull/5156>
          libsForQt5.qtstyleplugins
          qt6Packages.qt6gtk2
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
}

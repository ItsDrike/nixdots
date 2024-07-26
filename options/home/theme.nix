{
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.myOptions.home-manager.theme = {
    gtk = {
      enable = mkEnableOption "GTK theming optionss";
      usePortal = mkEnableOption "native desktop portal use for filepickers";

      theme = {
        name = mkOption {
          type = types.str;
          default = "Tokyonight-Dark-BL";
          description = "The name for the GTK theme package";
        };

        package = mkOption {
          type = types.package;
          description = "The theme package to be used for GTK programs";
          default = pkgs.tokyo-night-gtk;
        };
      };

      iconTheme = {
        name = mkOption {
          type = types.str;
          description = "The name for the icon theme that will be used for GTK programs";
          default = "Papirus-Dark";
        };

        package = mkOption {
          type = types.package;
          description = "The GTK icon theme package to be used";
          default = pkgs.catppuccin-papirus-folders.override {
            accent = "blue";
            flavor = "mocha";
          };
        };
      };

      font = {
        name = mkOption {
          type = types.str;
          description = "The name of the font that will be used for GTK applications";
          default = "Noto Sans"; # Lexend
        };

        size = mkOption {
          type = types.int;
          description = "The size of the font";
          default = 10; # 10
        };
      };
    };

    qt = {
      forceGtk = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to force QT applications to try and use the GTK theme.

          If false, qtct platform theme & Kvantum will be used instead.
        '';
      };

      kvantumTheme = {
        name = mkOption {
          type = types.str;
          default = "Catppuccin-Mocha-Blue";
          description = ''
            The name for the QT kvantum theme.

            This needs to match the directory containing the kvconfig & svg files
            for selected theme. The package should expose these in /share/Kvantum.

            This has no effect if forceGtk is set.
          '';
        };

        package = mkOption {
          type = types.package;
          description = ''
            The theme package to be used for QT kvantum theme.

            This needs to expose a directory in /share/Kvantum with the
            kvconfig & svg files. The name of this directory should match
            the kvantumTheme.name option.

            This has no effect if forceGtk is set.
          '';
          default = pkgs.catppuccin-kvantum.override {
            variant = "Mocha";
            accent = "Blue";
          };
        };
      };

      iconTheme = {
        name = mkOption {
          type = types.str;
          description = ''
            The name for the icon theme that will be used for QT programs.

            This has no effect if forceGtk is set.
          '';
          default = "Papirus-Dark";
        };

        package = mkOption {
          type = types.package;
          description = ''
            The QT icon theme package to be used.

            This has no effect if forceGtk is set.
          '';
          default = pkgs.catppuccin-papirus-folders.override {
            accent = "blue";
            flavor = "mocha";
          };
        };
      };
    };

    cursor = {
      name = mkOption {
        type = types.str;
        default = "BreezeX-RosePine-Linux";
        description = "The name of the cursor inside the package";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.rose-pine-cursor;
        description = "The package providing the cursors";
      };

      size = mkOption {
        type = types.int;
        default = 24;
        description = "The size of the cursor";
      };
    };
  };
}

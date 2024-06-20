{ lib, pkgs, ... }: let
  inherit (lib) mkEnableOption mkOption types;
in 
{
  options.myOptions.home-manager.theme = {
    gtk = {
      enable = mkEnableOption "GTK theming optionss";
      usePortal = mkEnableOption "native desktop portal use for filepickers";

      theme = {
        name = mkOption {
          type = types.str;
          default = "Catppuccin-Mocha-Standard-Blue-dark";
          description = "The name for the GTK theme package";
        };

        package = mkOption {
          type = types.package;
          description = "The theme package to be used for GTK programs";
          default = pkgs.catppuccin-gtk.override {
            size = "standard";
            accents = ["blue"];
            variant = "mocha";
            tweaks = ["normal"];
          };
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
          default = 10;  # 10
        };
      };
    };

    qt = {
      forceGtk = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to force QT applications to try and use the GTK theme.";
      };

      theme = {
        name = mkOption {
          type = types.str;
          default = "Catppuccin-Mocha-Dark";
          description = "The name for the QT theme package";
        };

        package = mkOption {
          type = types.package;
          description = "The theme package to be used for QT programs";
          default = pkgs.catppuccin-kde.override {
            flavour = ["mocha"];
            accents = ["blue"];
            winDecStyles = ["modern"];
          };
        };
      };
    };

    cursor = {
      name = mkOption {
        type = types.str;
        default = "catppuccin-mocha-dark-cursors";
        description = "The name of the cursor inside the package";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.catppuccin-cursors.mochaDark;
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

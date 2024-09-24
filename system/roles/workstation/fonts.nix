{pkgs, ...}: {
  fonts = {
    enableDefaultPackages = false;

    fontconfig = {
      defaultFonts = let
        common = [
          "Iosevka Nerd Font"
          "Symbols Nerd Font"
          "Noto Color Emoji"
        ];
      in {
        monospace =
          [
            "Monaspace Krypton"
            "Source Code Pro Medium"
            "Source Han Mono"
          ]
          ++ common;

        sansSerif =
          [
            "Noto Sans"
            "Jost"
            "Lexend"
          ]
          ++ common;

        serif =
          [
            "Noto Serif"
          ]
          ++ common;

        emoji =
          [
            "Noto Color Emoji"
          ]
          ++ common;
      };
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };

    packages = with pkgs; [
      # programming fonts
      sarasa-gothic
      source-code-pro
      monaspace

      # desktop fonts
      corefonts # MS fonts
      b612 # high legibility
      material-icons
      material-design-icons
      roboto
      work-sans
      comic-neue
      source-sans
      inter
      lato
      lexend
      jost
      dejavu_fonts
      noto-fonts
      noto-fonts-cjk

      # emojis
      noto-fonts-color-emoji
      twemoji-color-font
      openmoji-color
      openmoji-black
      font-awesome
      material-symbols

      # defaults worth keeping
      dejavu_fonts
      freefont_ttf
      gyre-fonts
      liberation_ttf
      unifont

      # specific nerd fonts only
      # (installing all nerd fonts is slow and takes gigabytes)
      # see: <https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/shas.nix>
      # for all available fonts
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
          "Iosevka"
          "NerdFontsSymbolsOnly"
          "FiraCode"
          "FiraMono"
          "Hack"
          "HeavyData"
          "Gohu"
        ];
      })
    ];
  };

  environment.systemPackages = with pkgs; [
    # Tool for searching and previewing installed fonts
    font-manager
  ];
}

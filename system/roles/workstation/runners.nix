{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    environment.systemPackages = [pkgs.appimage-run];

    # run appimages with appimage-run
    boot.binfmt.registrations = lib.genAttrs ["appimage" "AppImage"] (_: {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
      magicOrExtension = "\\x7fELF....AI\\x02";
    });

    # run unpatched linux binaries with nix-ld
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        openssl
        curl
        glib
        util-linux
        glibc
        icu
        libunwind
        libuuid
        zlib
        libsecret
        # graphical
        freetype
        libglvnd
        libnotify
        SDL2
        vulkan-loader
        gdk-pixbuf
        xorg.libX11
      ];
    };

    # Some pre-compiled binaries hard-code ssl cert file to /etc/ssl/cert.pem
    # instead of what NixOS uses (/etc/ssl/certs/ca-certificates.crt). Make a
    # symlink there for compatibility.
    # - For example the rye installed python binaries look there
    environment.etc."ssl/cert.pem".source = "/etc/ssl/certs/ca-certificates.crt";
  };
}

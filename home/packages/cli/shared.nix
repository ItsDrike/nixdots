{ config, pkgs, lib, ... }:
let
  username = config.myOptions.system.username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      fzf # fuzzy finder
      jq # JSON processor
      zip # compression/archiver for creating .zip files
      unzip # extraction util for .zip files
      file # show type of file
      rsync # incremental file transfer util
      btop # system monitor
      hyperfine # benchmarker
      delta # git delta viewer
      gnupg # encryption
      bc # GNU calculator
      mediainfo # shows tags/info about video/audio files
      usbutils # tools for working with usb devices (like lsusb)
      hexyl # hex viewer
      strace # linux system call tracer
      yt-dlp # media downloader
      glow # markdown renderer
      xdg-ninja # check $HOME for unwanted files
      nettools # Various tools for controlling the network
      dnsutils # DNS utilities
      dig # DNS utilities
      curl # CLI tool for transfering data with URLs

      # Rust replacements
      procs # better ps
      ripgrep # better grep
      fd # better find
      du-dust # better du
      bat # better cat

      # Development
      gcc # GNU C compiler
      cmake # build system generator
      meson # C/C++ build system
      gh # GitHub CLI tool
    ];
  };
}

{ pkgs, ... }: {
  home.packages = with pkgs; [
    fzf # fuzzy finder
    jq # JSON processor
    zip # compression/archiver for creating .zip files
    unzip # extraction util for .zip files
    file # show type of file
    rsync # incremental file transfer util
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
    lm_sensors # tools for reading hw sensors
    p7zip # 7zip fork with some improvements

    # Rust replacements
    procs # better ps
    ripgrep # better grep
    fd # better find
    du-dust # better du
    skim # fuzzy finder

    # Development
    gcc # GNU C compiler
    cmake # build system generator
    meson # C/C++ build system
  ];
}

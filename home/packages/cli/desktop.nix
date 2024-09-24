{pkgs, ...}: {
  # TODO: Only apply this to workstations
  home.packages = with pkgs; [
    libnotify # send desktop notifications
    imagemagick # create/edit images
    trash-cli # interface to freedesktop trashcan
    bitwarden-cli # pw manager
    slides # terminal based presentation tool
    brightnessctl # brightness control
    pulsemixer # manage audio (TUI)
    nix-tree # interactively browse nix store
    glow # render markdown
    ffmpeg # record, convert and stream audio and video
  ];
}

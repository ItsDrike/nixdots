{ pkgs, ... }: {

  # Install an actually usable system-wide editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  environment.systemPackages = with pkgs; [
    curl
    wget
    pciutils
    lshw
    man-pages
    rsync
    bind.dnsutils
  ];
}

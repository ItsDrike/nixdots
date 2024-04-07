{ pkgs, ... }: {

  # Install an actually usable system-wide editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };
}

{pkgs, ...}: {
  # TODO: Consider switching to nixvim, this is a temporary solution

  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Packages required for:
    # - Mason to build various language servers / linters / formatters from source
    # - Runtime dependencies of plugins / lang servers / ...
    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      go
      python3
      rustc
      cargo
      gcc
    ];
  };

  # Running `nvim --headless +q` is recommended
  # before opening neovim for the first time
  home.file."./.config/nvim" = {
    source = pkgs.fetchFromGitHub {
      owner = "ItsDrike";
      repo = "AstroNvimUser";
      rev = "v0.1.2";
      sha256 = "sha256-PPejIy8BGxilcFAvBZQVfVDwTNEm1Tu6e0AlzIZbYXY=";
    };
    recursive = true;
  };
}

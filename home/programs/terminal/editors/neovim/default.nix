{pkgs, ...}: {
  # TODO: Consider switching to nixvim

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
}

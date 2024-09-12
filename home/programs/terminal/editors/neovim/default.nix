{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;

    # Packages required for:
    #
    # - Mason to build various language servers / linters / formatters from source
    # - Runtime dependencies of plugins / lang servers / ...
    withNodeJs = true;
    withPython3 = true;
    extraPackages = with pkgs; [
      # Tools for building Mason packages
      go
      python3
      rustc
      cargo
      gcc
      cmake
      gnumake

      # lang servers
      lua-language-server
      rust-analyzer
      taplo
      gopls
      marksman
      yaml-language-server
      ruff
      neocmakelsp
      bash-language-server
      nixd
      emmet-language-server

      # Linters / formatters
      stylua
      shfmt
      gofumpt
      gotools
      sqlfluff
      hadolint
      markdownlint-cli2
      nodePackages.prettier
      shellcheck
      shfmt
      alejandra
      deadnix
      statix

      # Other tools / utilities
      ripgrep
      fd
      jq
      lazygit
    ];
  };
}

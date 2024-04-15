{ config, ... }: {
  programs = {
    # nix-index is a file database for nixpkgs
    # this provides `nix-locate` command.
    nix-index = {
      enable = true;
      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };

    # Allows interactive shells to show which Nix package (if any)
    # provides a missing command.
    command-not-found.enable = true;
  };
}

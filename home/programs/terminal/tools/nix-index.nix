{config, ...}: {
  programs = {
    # nix-index is a file database for nixpkgs
    # this provides `nix-locate` command.
    nix-index = {
      enable = true;
      # Attempt to find the package that contains the non-existent command
      enableBashIntegration = config.programs.bash.enable;
      enableZshIntegration = config.programs.zsh.enable;
    };
  };
}

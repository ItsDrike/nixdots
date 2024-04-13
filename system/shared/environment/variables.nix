{
  # variables that I want to set globally on all systems

  environment.variables = {
    # editors
    EDITOR = "nvim";
    VISUAL = "nvim";
    SUDO_EDITOR = "nvim";

    # pager stuff
    SYSTEMD_PAGERSECURE = "true";
    PAGER = "less -FR";
    MANPAGER = "nvim +Man!";
  };
}

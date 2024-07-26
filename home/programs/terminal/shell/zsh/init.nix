_: let
  inherit (builtins) readFile;
in {
  # I prefer having the rc files split across multiple files in my system rather
  # than just using readFile and putting them all into the generated zshrc
  # this also allows me to source them individually if I need to
  # (like in the anonymize function with my prompt)
  home.file = {
    # TODO: Load these dynamically, by going over all files in ./rc
    ".config/zsh/rc/fallback_term.zsh".source = ./rc/fallback_term.zsh;
    ".config/zsh/rc/opts.zsh".source = ./rc/opts.zsh;
    ".config/zsh/rc/prompt.zsh".source = ./rc/prompt.zsh;
    ".config/zsh/rc/keybinds.zsh".source = ./rc/keybinds.zsh;
    ".config/zsh/rc/aliases.zsh".source = ./rc/aliases.zsh;
    ".config/zsh/rc/functions.zsh".source = ./rc/functions.zsh;
    ".config/zsh/rc/misc.zsh".source = ./rc/misc.zsh;
    ".config/zsh/rc/completion.zsh".source = ./rc/completion.zsh;
    ".config/zsh/rc/profile.zsh".source = ./rc/profile.zsh;
  };

  programs.zsh = {
    initExtraFirst = ''
      # Do this early so anything that relies on $TERM can work properly
      . ~/.config/zsh/rc/fallback_term.zsh
    '';

    initExtra = ''
      . ~/.config/zsh/rc/opts.zsh
      . ~/.config/zsh/rc/prompt.zsh
      . ~/.config/zsh/rc/keybinds.zsh

      . ~/.config/zsh/rc/aliases.zsh
      . ~/.config/zsh/rc/functions.zsh
      . ~/.config/zsh/rc/misc.zsh
    '';

    completionInit = ''
      . ~/.config/zsh/rc/completion.zsh
    '';

    profileExtra = ''
      . ~/.config/zsh/rc/profile.zsh
    '';
  };
}

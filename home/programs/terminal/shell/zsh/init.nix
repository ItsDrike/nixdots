_:
let
  inherit (builtins) readFile;
in
{
  config = {
    programs.zsh = {
      initExtraFirst = ''
        # Do this early so anything that relies on $TERM can work properly
        ${readFile ./rc/fallback_term.zsh}
      '';

      initExtra = ''
        ${readFile ./rc/opts.zsh}
        ${readFile ./rc/prompt.zsh}
        ${readFile ./rc/keybinds.zsh}

        ${readFile ./rc/aliases.zsh}
        ${readFile ./rc/functions.zsh}
        ${readFile ./rc/misc.zsh}
      '';

      completionInit = ''
        ${readFile ./rc/completion.zsh}
      '';

      profileExtra = ''
        ${readFile ./rc/profile.zsh}
      '';

      envExtra = ''
        ${readFile ./rc/environment.zsh}
      '';
    };
  };
}

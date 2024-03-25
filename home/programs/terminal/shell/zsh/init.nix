_:
let
  inherit (builtins) readFile;
in
{
  config = {
    programs.zsh = {
      initExtra = ''
        ${readFile ./rc/opts.zsh}
        ${readFile ./rc/prompt.zsh}
        ${readFile ./rc/keybinds.zsh}
        ${readFile ./rc/fallback_term.zsh}

        ${readFile ./rc/aliases.zsh}
        ${readFile ./rc/functions.zsh}
      '';

      completionInit = '''
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

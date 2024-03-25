# Autocompletion behavior of ZSH

autoload -Uz compinit
zmodload -i zsh/complist                # load completion list
compinit -d $ZSH_COMPDUMP               # Specify compdump file
zstyle ':completion:*' menu select      # select completions with arrow keys
zstyle ':completion:*' group-name ''    # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate #enable approximate matches for completion

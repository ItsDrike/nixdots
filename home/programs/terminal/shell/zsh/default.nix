{ config, pkgs, ... }: {
  imports = [
    ./plugins.nix
    ./aliases.nix
    ./init.nix
  ];

  config = {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      history = {
        # don't clutter $HOME
        path = "${config.xdg.dataHome}/zsh/zsh_history";

        save = 120000;
        size = 100000;
      };

      # dirhashes are easy aliases to commonly used directories
      # allowing use like `cd ~dl`, going to $HOME/Downloads
      dirHashes = {
        dl = "$HOME/Downloads";
        media = "$HOME/Media";
        pics = "$HOME/Media/Pictures";
        vids = "$HOME/Media/Videos";
        mems = "$HOME/Media/Memes";
        screenshots = "$HOME/Media/Pictures/Screenshots";
        dots = "$HOME/dots";
      };
    };
  };
}

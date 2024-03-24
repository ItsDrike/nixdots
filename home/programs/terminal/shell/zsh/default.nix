{ config, pkgs, ... }: {
  imports = [
    ./plugins.nix
    ./aliases.nix
  ];

  config = {
    programs.zsh = {
      enable = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableAutosuggestions = true;
      autocd = true;

      history = {
        # share history across different running zsh session
        share = true;

        # don't clutter $HOME
        path = "${config.xdg.dataHome}/zsh/zsh_history";

        # save timestamps to histfile
        extended = true;

        save = 120000;
        size = 100000;

        # If the internal history needs to be trimmed to add the current command line,
        # this will cause the oldest history event that has a duplicate to be lost before
        # losing a unique event from the list. You should set the value of history size
        # to a larger number than the save size in order to give some room for the duplicated
        # events, otherwise this option will behave just like ignoreDups once history fills
        # up with unique events.
        expireDuplicatesFirst = true;

        # If a new command line being added to the history list duplicates an older one,
        # the older command is removed from the list (even if it is not the previous event).
        ignoreAllDups = true;

        # Don't track command lines in the history list when the first character on the line
        # is a space, or when one of the expanded aliases contains a leading space. Note that
        # the command lingers in the internal session history until the next command is entered
        # before it vanishes, allowing you to briefly reuse or edit the line.
        ignoreSpace = true;
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

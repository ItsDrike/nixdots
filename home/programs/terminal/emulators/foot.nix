{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    libsixel # for displaying images
  ];
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        # window settings
        app-id = "foot";
        title = "foot";
        locked-title = "no";
        term = "xterm-256color";
        shell = "zsh";

        # notifications
        notify = "notify-send -a \${app-id} -i \${app-id} \${title} \${body}";
        selection-target = "clipboard";

        # font and font rendering
        dpi-aware = false; # this looks more readable on a laptop, but it's unreasonably large
        font = "Monaspace Krypton:size=11";
        font-bold = "Monaspace Krypton:size=11";
      };

      colors = {
        alpha = 0.9;
        background = "191919";
        foreground = "d8dee9";
      };

      scrollback = {
        lines = 10000;
        multiplier = 3;
      };

      tweak = {
        font-monospace-warn = "no"; # reduces startup time
        sixel = "yes";
      };

      cursor = {
        style = "beam";
        beam-thickness = 2;
      };

      mouse = {
        hide-when-typing = "yes";
      };

      url = {
        launch = "xdg-open \${url}";
        label-letters = "sadfjklewcmpgh";
        osc8-underline = "url-mode";
        protocols = "http, https, ftp, ftps, file";
        uri-characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-_.,~:;/?#@!$&%*+=\"'()[]";
      };
    };
  };
}


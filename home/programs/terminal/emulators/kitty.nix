{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (osConfig) modules;
  inherit (modules.style.colorScheme) colors;
in {
  programs.kitty = {
    enable = true;
    settings = {
      # Font & Text style
      font_family = "Monaspace Krypton";
      font_size = 11;
      disable_ligatures = "never";

      # Dark Theme
      foreground = "#d8dee9";
      background = "#191919";
      # White theme (for screenshots in papers)
      #foreground = "#191919";
      #background = "#FFFFFF";

      # URLs
      url_color = "#0087bd";
      url_style = "curly";

      # Cursor
      cursor = "#D0D0D0";
      cursor_shape = "underline";
      cursor_blink_interval = "0.5";
      cursor_stop_blinking_after = "15.0";

      # Background
      background_opacity = "0.9";
      dynamic_background_opacity = "yes";
      background_blur = 2;

      # Window size
      remember_window_size = false;
      initial_window_width = 640;
      initial_window_height = 400;

      # Bell
      visual_bell_duration = "0.0"; # flash the screen for this duration when bell occurs
      enable_audio_bell = false; # disable audio bells

      # Misc
      update_check_interval = 0; # don't check for updates, we have a package manager...
      confirm_os_window_close = 0; # don't ask for confirmation if window gets closed
      scrollback_lines = 10000; # Capture up to 10k lines for scrolling
      select_by_word_characters = ":@-./_~?&=%+#"; # chars considered part of word when double clicking
    };
    keybindings = {
      "ctrl+c" = "copy_or_interrupt";
      "ctrl+alt+c" = "copy_to_clipboard";
      "ctrl+alt+v" = "paste_from_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";

      "ctrl+shift+up" = "increase_font_size";
      "ctrl+shift+down" = "decrease_font_size";
      "ctrl+shift+backspace" = "restore_font_size";

      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+n" = "new_os_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";
      "ctrl+shift+f" = "move_window_forward";
      "ctrl+shift+b" = "move_window_backward";
      "ctrl+shift+`" = "move_window_to_top";
      "ctrl+shift+1" = "first_window";
      "ctrl+shift+2" = "second_window";
      "ctrl+shift+3" = "third_window";
      "ctrl+shift+4" = "fourth_window";
      "ctrl+shift+5" = "fifth_window";
      "ctrl+shift+6" = "sixth_window";
      "ctrl+shift+7" = "seventh_window";
      "ctrl+shift+8" = "eighth_window";
      "ctrl+shift+9" = "ninth_window";
      "ctrl+shift+0" = "tenth_window";

      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "ctrl+shift+l" = "next_layout";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+," = "move_tab_backward";
      "ctrl+shift+alt+t" = "set_tab_title";
    };
  };
}

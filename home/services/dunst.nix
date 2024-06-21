{
  lib,
  osConfig,
  config,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.services.dunst;
in {
  config = mkIf cfg.enable {
    services.dunst = {
      enable = true;
      iconTheme = {
        package = config.gtk.iconTheme.package;
        name = config.gtk.iconTheme.name;
      };

      settings = {
        global = {
          follow = "mouse";
          width = 270;
          height = 300;
          origin = "top-right";
          offset = "30x30";
          scale = 0;
          alignment = "left";
          vertical_alignment = "center";
          ellipsize = "middle";
          padding = 10;
          horizontal_padding = 10;
          text_icon_padding = 0;
          icon_position = "left";
          min_icon_size = 0;
          max_icon_size = 32;
          separator_height = 2;
          frame_width = 3;
          frame_color = "#27292c";
          separator_color = "frame";
          corner_radius = 0;
          transparency = 20;
          word_wrap = "yes";
          line_height = 0;
          notification_limit = 3;
          idle_threshold = 120;
          history_length = 20;
          show_age_threshold = 60;
          markup = "full";
          format = "<b>%a - %s</b>\\n%b";
          font = "JetBrainsMono Nerd Font 11";
          sort = "yes";
          shrink = "no";
          sticky_history = "yes";
          ignore_newline = "no";
          show_indicators = "yes";
          stack_duplicates = true;
          always_run_script = true;
          hide_duplicate_count = false;
          ignore_dbusclose = false;
          force_xwayland = false;
          force_xinerama = false;
          mouse_left_click = "do_action, open_url, close_current";
          mouse_middle_click = "context";
          mouse_right_click = "close_current";
          indicate_hidden = "yes";
          progress_bar = true;
          progress_bar_height = 30;
          progress_bar_frame_width = 1;
          progress_bar_min_width = 150;
          progress_bar_max_width = 300;
          title = "Dunst";
          class = "Dunst";
        };

        fullscreen_delay_everything = {fullscreen = "delay";};

        urgency_low = {
          timeout = 5;
          background = "#1e2137fa";
          foreground = "#ffffff";
          highlight = "#fe6c5a";
        };

        urgency_normal = {
          timeout = 10;
          background = "#141c21fa";
          foreground = "#ffffffff";
          highlight = "#fe6c5a";
        };

        urgency_critical = {
          timeout = 0;
          background = "#dd130ddd";
          foreground = "#ffffffff";
          highlight = "#fe6c5a";
        };
      };
    };
  };
}

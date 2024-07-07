{
  inputs,
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.myOptions.home-manager.programs.launchers.walker;
in {
  imports = [ inputs.walker.homeManagerModules.walker ];
  config = mkIf cfg.enable {
    programs.walker = {
      enable = true;
      runAsService = true; # makes walker a lot faster when starting

      config = {
        placeholder = "Search...";
        ignore_mouse = false;
        terminal = "kitty";
        shell_config = "${config.xdg.configHome}/zsh/.zshrc";
        ssh_host_file = "${config.home.homeDirectory}/.ssh/known_hosts";
        enable_typeahead = false;
        show_initial_entries = true;
        fullscreen = false;
        scrollbar_policy = "automatic";
        websearch = {
         engines = ["google" "duckduckgo"];
        };
        hyprland = {
          context_aware_history = false;
        };
        applications = {
          enable_cache = false;  # disabling doesn't cause slowdowns, and allows picking up new apps automatically
        };

        # Mode for picking the entry with keyboard using labels
        # defaults to ctrl+<entry label>
        activation_mode = {
          disabled = false;
          use_f_keys = false; # F-keys instead of letters for labels
          use_alt = false; # use alt instead of ctrl to enter activation mode
        };
        search = {
          delay = 0; # debounce delay (until src/cmd is ran) in ms
          hide_icons = false;
          margin_spinner = 10; # margin of the spinner in px
          hide_spinner = false;
        };
        runner = {
          excludes = ["rm"];  # commands to be excluded from the runner
        };
        clipboard = {
          max_entries = 10;
          image_height = 300;
        };
        align = {
          ignore_exclusive = true;
          width = 400;
          horizontal = "center";
          vertical = "start";
          anchors = {
            top = false;
            left = false;
            bottom = false;
            right = false;
          };
          margins = {
            top = 20;
            bottom = 0;
            end = 0;
            start = 0;
          };
        };
        list = {
          height = 300;
          width = 100;
          margin_top = 10;
          always_show = true;
          hide_sub = false;
          fixed_height = false;
        };
        orientation = "vertical";
        icons = {
          theme = "";  # GTK Icon theme (default)
          hide = false;
          size = 28;
          image_height = 200;
        };
        # Built-in modules
        modules = [
          # Module switcher
          {
            name = "switcher";
            prefix = "/";
          }

          # Default modules (always listed)
          {
            name = "runner";
            prefix = "";
          }
          {
            name = "applications";
            prefix = "";
          }

          # Prefix modules
          {
            name = "hyprland";
            prefix = "#";
          }
          {
            name = "clipboard";
            prefix = ">";
          }

          # Switcher exclusive modules (must be chosen)
          {
            name = "commands"; # walker commands
            prefix = "";
            switcher_exclusive = true;
          }
          {
            name = "ssh";
            prefix = "";
            switcher_exclusive = true;
          }
          {
            name = "websearch";  # uses google
            prefix = "";
            switcher_exclusive = true;
          }
        ];
        # Custom modules
        external = [
          {
            name = "Home directory explorer";
            prefix = "~";
            src = "fd --base-directory ~ %TERM%";
            cmd = "xdg-open file://%RESULT%";
          }
          {
            name = "DDG search";
            prefix = "?";
            src = "jq -sRr '@uri'";
            cmd = "xdg-open https://duckduckgo.com/?t=h_&q=%RESULT%&ia=web";
          }
        ];
      };
      style = builtins.readFile ./style.css;
    };
  };
}

{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.screen-lockers.hyprlock;
in {
  config = mkIf cfg.enable {
    programs.hyprlock = {
      enable = true;

      settings = {
        general = {
          disable_loading_bar = false;
          hide_cursor = true;
          grace = 3;
        };

        background = [
          {
            # TODO: Keep the wallpaper in dotfiles
            path = "~/Media/Pictures/Wallpapers/Categories/Extra/origami.png";
            blur_passes = 3;
            blur_size = 6;
            #contrast = 0.7;
            #brightness = 0.7;
            noise = 0.01;
            contrast = 0.9;
            brightness = 0.6;
          }
        ];

        # Password circle
        input-field = [
          {
            size = "300, 250";
            rounding = -1;
            outline_thickness = 30;
            outer_color = "rgba(129, 162, 190, 85)";
            inner_color = "rgb(29, 31, 33)";
            font_color = "rgb(100, 100, 100)";

            check_color = "rgb(204, -136, 34)"; # override outer_color while checking the pw (could take a while sometimes - pam lockouts)
            fail_color = "rgb(204, 34, 34)"; # override outer_color and fail message color if auth failed
            fail_transition = 500; # transition time in ms between normal outer_color and fail_color
            fail_text = ""; # Leave this empty (amt of attempts and fail reason shown with labels)

            hide_input = true;
            fade_on_empty = false;
            placeholder_text = ""; # Leave this empty

            position = "0, 0";
            halign = "center";
            valign = "center";
          }
        ];

        label = [
          # Show time (inside of the circle)
          {
            text = "cmd[update:200] date +'%H:%M:%S'";
            color = "rgba(129, 162, 190, 1.0)";
            font_size = 35;
            font_family = "Noto Sans";

            position = "0, 30";
            halign = "center";
            valign = "center";
          }

          # Show date (inside of the circle, below time)
          {
            text = "cmd[update:1000] date +'%a, %d-%m-%Y'";
            color = "rgba(129, 162, 190, 1.0)";
            font_size = 20;
            font_family = "Noto Sans";

            position = "0, -20";
            halign = "center";
            valign = "center";
          }

          # Keyboard layout
          {
            text = "cmd[update:200] hyprctl devices -j | jq -r '.keyboards[] | select(.name == \"at-translated-set-2-keyboard\") | .active_keymap'";
            color = "rgba(129, 162, 190, 1.0)";
            font_size = 10;
            font_family = "Noto Sans";

            position = "0, -90";
            halign = "center";
            valign = "center";
          }

          # Failed attempts count
          {
            text = "<i>Logged <span foreground='##FFA500'>$ATTEMPTS[0]</span> failure(s)</i>";
            color = "rgba(153, 153, 153, 1.0)"; # gray
            font_size = 14;
            font_family = "Noto Sans";

            shadow_passes = 1;
            shadow_size = 1.2;
            shadow_boost = 1.0;

            position = "0, -200";
            halign = "center";
            valign = "center";
          }

          # Fail reason
          {
            text = "<i>$FAIL</i>";
            color = "rgba(255, 34, 34, 1.0)"; # red
            font_size = 14;
            font_family = "Noto Sans";

            shadow_passes = 1;
            shadow_size = 1.2;
            shadow_boost = 1.0;

            position = "0, -230";
            halign = "center";
            valign = "center";
          }

          # Splash text
          {
            text = "Session Locked";
            color = "rgba(255, 255, 255, 1.0)";
            font_size = 40;
            font_family = "Monaspace Krypton";

            shadow_passes = 1;
            shadow_size = 5;
            shadow_boost = 1.8;

            position = "0, 220";
            halign = "center";
            valign = "center";
          }

          # Device uptime
          {
            text = "cmd[update:1000] echo \"  $(awk '{days=int($1/86400); hours=int(($1%86400)/3600); minutes=int(($1%3600)/60); if (days>0) printf \"%dd %dh %dm\\n\", days, hours, minutes; else if (hours>0) printf \"%dh %dm\\n\", hours, minutes; else printf \"%dm\\n\", minutes; }' /proc/uptime)\"";
            color = "rgba(129, 162, 190, 1.0)";
            font_size = 11;
            font_family = "Noto Sans";

            position = "-90, -20";
            halign = "right";
            valign = "top";
          }

          # Battery percentage
          {
            text = "cmd[update:1000] echo \"   $(cat /sys/class/power_supply/BAT0/capacity)%\"";
            color = "rgba(129, 162, 190, 1.0)";
            font_size = 11;
            font_family = "Noto Sans";

            shadow_passes = 1;
            shadow_size = 5;
            shadow_boost = 1.8;

            position = "-20, -20";
            halign = "right";
            valign = "top";
          }

          # User account
          {
            text = "   $USER";
            color = "rgba(129, 162, 190, 1.0)";
            font_size = 11;
            font_family = "Noto Sans";

            shadow_passes = 1;
            shadow_size = 5;
            shadow_boost = 1.8;

            position = "20, -20";
            halign = "left";
            valign = "top";
          }

          # Recovery email (lost device)
          {
            text = "recovery@itsdrike.com";
            color = "rgba(129, 162, 190, 1.0)";
            font_size = 11;
            font_family = "Noto Sans";

            shadow_passes = 1;
            shadow_size = 5;
            shadow_boost = 1.8;

            position = "20, 12";
            halign = "left";
            valign = "bottom";
          }
        ];
      };
    };
  };
}

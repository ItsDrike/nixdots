{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.services.hypridle;
  cfgIsWayland = osConfig.myOptions.home-manager.wms.isWayland;
in {
  config = mkIf (cfg.enable && cfgIsWayland) {
    # NOTE: This assumes dunst, hyprlock and Hyprland are installed
    services.hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "hyprlock";
          unlock_cmd = "killall -s SIGUSR1 hyprlock && dustctl set-paused false";
          before_sleep_cmd = "loginctl lock-session && dunstctl set-paused true && sleep 2";
          ignore_dbus_inhibit = false;
          ignore_systemd_inhibit = false;
        };

        listener = [
          # Warn about going idle (5 mins)
          {
            timeout = 300;
            # use hyprland notifications, in case dunst notifs are paused or whatever
            on-timeout = "hyprctl notify 0 10000 'rgb(ff0000)' 'fontsize:20    System going idle in 10 seconds...'";
            on-resume = "hyprctl dismissnotify 1";
          }

          # Lock the session & disable dunst notifications
          {
            timeout = 310;
            on-timeout = "loginctl lock-session && dunstctl set-paused true";
            on-resume = "dunstctl set-paused false";
          }

          # Turn off the screen after another 50s
          {
            timeout = 400;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }

          # Enter suspend/sleep state (10 minutes)
          {
            timeout = 600;
            on-timeout = "systemctl suspend";
          }
        ];
      };
    };
  };
}

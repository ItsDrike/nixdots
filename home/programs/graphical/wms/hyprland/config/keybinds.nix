{
  config,
  osConfig,
  ...
}: let
  cfgPreferences = osConfig.myOptions.home-manager.preferences;
in {
  wayland.windowManager.hyprland = {
    settings = {
      "$MOUSE_LMB" = "mouse:272";
      "$MOUSE_RMB" = "mouse:273";
      "$MOUSE_MMB" = "mouse:274";
      "$MOUSE_EX1" = "mouse:275";
      "$MOUSE_EX2" = "mouse:276";

      "$XF86Favorites" = "164";

      "$SCREENSHOT_FORMAT" = "${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}/Screenshot_''$(date +%Y-%m-%d_%H-%M-%S).png";
      "$SCREENSHOT_DELAY" = "2000";

      bind = [
        #
        # Active window
        #
        "SUPER, W, killactive,"
        "SUPER, F, togglefloating,"
        "SUPER, Space, fullscreen, 0" # regular fullscreen
        "SUPER_SHIFT, Space, fullscreen, 1" # maximize without client fullscreen
        "SUPER_CTRL, Space, fullscreenstate, 2, 0" # fullscreen without client knowing
        "SUPER_CTRL_SHIFT, Space, fullscreenstate, 1, 2" # maximize with client being full-screen
        "CTRL_SHIFT, Space, exec, toggle-fake-fullscreen" # fake fullscreen + custom border
        "SUPER_SHIFT, S, layoutmsg, togglesplit"

        #
        # Programs
        #
        "SUPER, Return, exec, ${cfgPreferences.terminalEmulator.command}"
        "SUPER, R, exec, ${cfgPreferences.launcher.command}"
        "SUPER, B, exec, ${cfgPreferences.browser.command}"
        "SUPER, X, exec, ${cfgPreferences.fileManager.command}"
        "SUPER, C, exec, qalculate-gtk"
        ", XF86Calculator, exec, qalculate-gtk"

        #
        # DE/WM Control programs
        #
        # TODO: Add menuquit
        "SUPER_SHIFT, L, exec, wlogout -p layer-shell"
        "SUPER_CTRL, L, exec, loginctl lock-session"
        "SUPER_SHIFT, T, exec, toggle-idle"

        #
        # Screenshots
        #
        "ALT, Print, exec, wl-copy \"$(hyprpicker)\" && notify-send 'Picked color' \"$(wl-paste) (saved to clipboard)\""
        ", Print, exec, hyprland-screenshot --notify --copy --target area"
        "SUPER, Print, exec, hyprland-screenshot --notify --copy --target area --edit"
        "SHIFT, Print, exec, hyprland-screenshot --notify --save $SCREENSHOT_FORMAT --target area"
        "CTRL, Print, exec, hyprland-screenshot --notify --copy --target area --delay $SCREENSHOT_DELAY"
        "SUPER_SHIFT, Print, exec, hyprland-screenshot --notify --save $SCREENSHOT_FORMAT --target area --edit"
        "SUPER_CTRL, Print, exec, hyprland-screenshot --notify --copy --target area --delay $SCREENSHOT_DELAY --edit"
        "SUPER_SHIFT_CTRL, Print, exec, hyprland-screenshot --notify --save $SCREENSHOT_FORMAT --target area --delay $SCREENSHOT_DELAY --edit"
        "CTRL, T, exec, hyprland-screenshot --save $SCREENSHOT_FORMAT --target all"
        #" , Print, exec, screenshot --save $SCREENSHOT_FORMAT --target all"

        # XF86Favorites key for recording
        # (don't question me, I had it free)
        ", $XF86Favorites, exec, quick-record --notify toggle"
        "SUPER, $XF86Favorites, exec, quick-record toggle"

        #
        # Brightness control
        #
        "SUPER, Right, exec, brightness 5%+"
        "SUPER, Left, exec, brightness 5%-"
        ", XF86MonBrightnessUp, exec, brightness 5%+"
        ", XF86MonBrightnessDown, exec, brightness 5%-"

        #
        # Audio/Volume control
        #
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        # (rest in binde section)

        #
        # Notifications
        #
        "CTRL, grave, exec, dunstctl close"
        "CTRL_SHIFT, grave, exec, dunstctl close-all"
        "CTRL, period, exec, dunstctl history-pop"
        "CTRL_SHIFT, period, exec, dunstctl context"
        "SUPER_SHIFT, D, exec, toggle-notifications"

        #
        # Window groups
        #
        "SUPER, G, togglegroup,"
        "SUPER_SHIFT, G, lockactivegroup, toggle"
        "ALT, tab, changegroupactive, f"
        "ALT, grave, changegroupactive, b"

        #
        # Special workspace (scratchpad)
        #
        "ALT, grave, movetoworkspace, special"
        "SUPER, grave, togglespecialworkspace,"

        #
        # Move window focus
        #
        "SUPER, h, movefocus, l"
        "SUPER, l, movefocus, r"
        "SUPER, k, movefocus, u"
        "SUPER, j, movefocus, d"

        #
        # Move active window in direction
        #
        "SUPER_ALT, h, movewindow, l"
        "SUPER_ALT, l, movewindow, r"
        "SUPER_ALT, k, movewindow, u"
        "SUPER_ALT, j, movewindow, d"

        #
        # Move floating windows
        #
        "SUPER_ALT, left, exec, hyprland-move-window 100 l"
        "SUPER_ALT, right, exec, hyprland-move-window 100 r"
        "SUPER_ALT, up, exec, hyprland-move-window 100 u"
        "SUPER_ALT, down, exec, hyprland-move-window 100 d"

        #
        # Override split direction for next window (manual tiling)
        #
        "SUPER_ALT, left, layoutmsg, preselect l"
        "SUPER_ALT, right, layoutmsg, preselect r"
        "SUPER_ALT, up, layoutmsg, preselect u"
        "SUPER_ALT, down, layoutmsg, preselect d"

        #
        # Switch workspace (swapping to current monitor)
        #
        "SUPER, 1, focusworkspaceoncurrentmonitor, 1"
        "SUPER, 2, focusworkspaceoncurrentmonitor, 2"
        "SUPER, 3, focusworkspaceoncurrentmonitor, 3"
        "SUPER, 4, focusworkspaceoncurrentmonitor, 4"
        "SUPER, 5, focusworkspaceoncurrentmonitor, 5"
        "SUPER, 6, focusworkspaceoncurrentmonitor, 6"
        "SUPER, 7, focusworkspaceoncurrentmonitor, 7"
        "SUPER, 8, focusworkspaceoncurrentmonitor, 8"
        "SUPER, 9, focusworkspaceoncurrentmonitor, 9"

        #
        # Move window to workspace
        #
        "SUPER_SHIFT, 1, movetoworkspacesilent, 1"
        "SUPER_SHIFT, 2, movetoworkspacesilent, 2"
        "SUPER_SHIFT, 3, movetoworkspacesilent, 3"
        "SUPER_SHIFT, 4, movetoworkspacesilent, 4"
        "SUPER_SHIFT, 5, movetoworkspacesilent, 5"
        "SUPER_SHIFT, 6, movetoworkspacesilent, 6"
        "SUPER_SHIFT, 7, movetoworkspacesilent, 7"
        "SUPER_SHIFT, 8, movetoworkspacesilent, 8"
        "SUPER_SHIFT, 9, movetoworkspacesilent, 9"

        #
        # Move window to workspace + focus it
        #
        "ALT, 1, movetoworkspace, 1"
        "ALT, 2, movetoworkspace, 2"
        "ALT, 3, movetoworkspace, 3"
        "ALT, 4, movetoworkspace, 4"
        "ALT, 5, movetoworkspace, 5"
        "ALT, 6, movetoworkspace, 6"
        "ALT, 7, movetoworkspace, 7"
        "ALT, 8, movetoworkspace, 8"
        "ALT, 9, movetoworkspace, 9"

        #
        # Cycle workspaces (relative movement)
        #
        "SUPER, mouse_down, workspace, +1"
        "SUPER, mouse_up, workspace, -1"
        "SUPER, bracketright, workspace, +1"
        "SUPER, bracketleft, workspace, -1"

        #
        # Cycle monitors (relative movement)
        #
        "SUPER_SHIFT, mouse_down, focusmonitor, +1"
        "SUPER_SHIFT, mouse_up, focusmonitor, -1"
        "SUPER_SHIFT, bracketright, focusmonitor, +1"
        "SUPER_SHIFT, bracketleft, focusmonitor, -1"

        #
        # Global keybinds (passing keys to other programs)
        #
        "CTRL, F10, pass, ^(com\.obsproject\.Studio)$"
      ];

      # Mouse bindings
      bindm = [
        #
        # Mouse window resizing
        #
        "SUPER, $MOUSE_LMB, movewindow"
        "SUPER, $MOUSE_RMB, resizewindow"
      ];

      # Repeat bindings
      binde = [
        #
        # Audio/Volume control
        #
        "SUPER, Down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
        "SUPER, Up, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
        # (rest in bind section)

        #
        # Window resizing
        #
        "ALT, right, resizeactive, 10 0"
        "ALT, left, resizeactive, -10 0"
        "ALT, up, resizeactive, 0 -10"
        "ALT, down, resizeactive, 0 10 "
        "ALT, H, resizeactive, -10 0"
        "ALT, K, resizeactive, 0 -10"
        "ALT, J, resizeactive, 0 10"
        "ALT, L, resizeactive, 10 0"
      ];
    };

    # Used for submaps, which don't support `settings`
    extraConfig = ''
      #
      # Isolation group
      #

      # Useful to prevent keybind capturing (for games, etc)
      # SUPER + End
      bind = SUPER, End, exec, hyprctl dispatch submap isolate && notify-send "Keybind isolation" "Keybind isolation on"
      submap = isolate
      bind = SUPER, End, exec, hyprctl dispatch submap reset && notify-send "Keybind isolation" "Keybind isolation off"
      submap = reset

      #
      # Precise keyboard window resizing
      #

      bind = SUPER, slash, submap, resize
      submap = resize

      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10

      binde = SUPER, right, resizeactive, 30 0
      binde = SUPER, left, resizeactive, -30 0
      binde = SUPER, up, resizeactive, 0 -30
      binde = SUPER, down, resizeactive, 0 30

      binde = SHIFT, right, resizeactive, 1 0
      binde = SHIFT, left, resizeactive, -1 0
      binde = SHIFT, up, resizeactive, 0 -1
      binde = SHIFT, down, resizeactive, 0 1

      binde = , H, resizeactive, -10 0
      binde = , K, resizeactive, 0 -10
      binde = , J, resizeactive, 0 10
      binde = , L, resizeactive, 10 0

      binde = , right, resizeactive, 10 0
      binde = , left, resizeactive, -10 0
      binde = , up, resizeactive, 0 -10
      binde = , down, resizeactive, 0 10

      binde = SUPER, H, resizeactive, -30 0
      binde = SUPER, K, resizeactive, 0 -30
      binde = SUPER, J, resizeactive, 0 30
      binde = SUPER, L, resizeactive, 30 0

      binde = SHIFT, H, resizeactive, -1 0
      binde = SHIFT, K, resizeactive, 0 -1
      binde = SHIFT, J, resizeactive, 0 1
      binde = SHIFT, L, resizeactive, 1 0

      bind = , escape, submap, reset
      bind = , return, submap, reset
      bind = SUPER, slash, submap, reset
      submap = reset
    '';
  };
}

{
  wayland.windowManager.hyprland.settings = {
    "$MOUSE_LMB" = "mouse:272";
    "$MOUSE_RMB" = "mouse:273";
    "$MOUSE_MMB" = "mouse:274";
    "$MOUSE_EX1" = "mouse:275";
    "$MOUSE_EX2" = "mouse:276";

    "$XF86Favorites" = "164";

    bind = [
      # 
      # Active window
      #
      "SUPER, W, killactive,"
      "SUPER, F, togglefloating,"
      "SUPER, Space, fullscreen, 0"
      "SUPER, Space, fullscreen, 1"  # maximize
      "SUPER_SHIFT, S, layoutmsg, togglesplit"

      #
      # Programs
      #
      "SUPER, Return, exec, kitty"
      # TODO: requires programs

      #
      # DE/WM Control programs
      #
      # TODO: Requires programs
      "SUPER_SHIFT, L, exec, wlogout -p layer-shell"

      #
      # Screenshots
      #
      # TODO: requires script

      #
      # Brightness control
      #
      # TODO: requires script


      #
      # Audio/Volume control
      #
      "SUPER, Down, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
      "SUPER, Up, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
      ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
      ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
      ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"

      #
      # Notifications
      #
      # TODO: Requires notification daemon (dunst?)


      #
      # Window groups
      #
      "SUPER, G, togglegroup,"
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
      "SUPER, 1, exec, hyprland-swap-workspace 1"
      "SUPER, 2, exec, hyprland-swap-workspace 2"
      "SUPER, 3, exec, hyprland-swap-workspace 3"
      "SUPER, 4, exec, hyprland-swap-workspace 4"
      "SUPER, 5, exec, hyprland-swap-workspace 5"
      "SUPER, 6, exec, hyprland-swap-workspace 6"
      "SUPER, 7, exec, hyprland-swap-workspace 7"
      "SUPER, 8, exec, hyprland-swap-workspace 8"
      "SUPER, 9, exec, hyprland-swap-workspace 9"

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
      # Window resizing
      #
      # TODO: Submaps + binde

      #
      # Isolation group
      #
      # TODO: Submaps
    ];

    bindm = [
      # Mouse window resizing
      "SUPER, $MOUSE_LMB, movewindow"
      "SUPER, $MOUSE_RMB, resizewindow"
    ];
  };
}

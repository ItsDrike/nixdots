{
  wayland.windowManager.hyprland.settings = {
    windowrulev2 = [
      #
      # Assigned workspaces
      #
      "workspace, 2, class:^(firefox)$"
      "workspace 4, class:^(discord)$"
      "workspace 4, class:^(vesktop)$"
      "workspace 4, class:^(WebCord)$"
      "workspace 5, class:^(Spotify)$"
      "workspace 6, class:^(Stremio)$"
      "workspace 6, class:^(com.stremio.stremio)$"

      #
      # Idle inhibition
      #
      "idleinhibit focus, class:^(Stremio)$"
      "idleinhibit focus, class:^(com.stremio.stremio)$"
      "idleinhibit focus, class:^(mpv)$"
      "idleinhibit focus, class:^(firefox)$,title:^(.+ - YouTube — Mozilla Firefox)$"
      "idleinhibit focus, class:^(firefox)$,title:^(Picture-in-Picture)$"

      #
      # Correct size / Auto tile
      #
      "size 800 550, class:^(qalculate-gtk)$"
      "tile, class:^(Spotify)$"

      #
      # Auto float
      #
      "float, class:^(Lxappearance)$"
      "float, class:^(Rofi)$"
      "float, class:^(feh)$"
      "float, class:^(pavucontrol-qt)$"
      "float, class:^(pavucontrol)$"
      "float, class:^(file-roller)$"
      "float, class:^(qalculate-gtk)$"
      "float, class:^(com.github.wwmm.easyeffects)"
      "float, class:^(opensnitch_ui)$"
      "float, class:^(Brave-browser)$,title:^(_crx_.+)$"
      "float, class:^(hyprland-share-picker)$"
      "float,class:^(floating)$"

      "center, class:^(hyprland-share-picker)$"
      "animation slide, class:^(hyprland-share-picker)$"

      # Float firefox windows (like bookmark menus, or some extension windows)
      "float, class:^(firefox)$,title:^(Revert Bookmarks)$"
      "float, class:^(firefox)$,title:^(Library)$"
      "float, class:^(firefox)$,title:^(Extension: \(uBlock Origin\))"
      "float, class:^(firefox)$,title:^(Firefox — Sharing Indicator)$"
      "float, class:^(firefox)$,title:^(Opening .+)$"
      "float, class:^(firefox)$,title:^$"

      # Float some pcmanfm windows
      "float, class:^(pcmanfm-qt)$,title:^(Mount)$"
      "float, class:^(pcmanfm-qt)$,title:^(Preferences)$"
      "float, class:^(pcmanfm-qt)$,title:^(Move files)$"
      "float, class:^(pcmanfm-qt)$,title:^(Search Files)$"
      "float, class:^(pcmanfm-qt)$,title:^(Copy Files)$"
      "float, class:^(pcmanfm-qt)$,title:^(Confirm to replace files)$"

      # Float some windows from other apps
      "float, class:^(Spotify)$,title:^(Ozone X11)$"
      "float, class:^(python3)$,title:^(Tor Browser Launcher Settings)$"
      "float, class:^(python3)$,title:^(Tor Browser)$"

      # General float rules
      "float, class:^(file_progress)$"
      "float, class:^(confirm)$"
      "float, class:^(dialog)$"
      "float, class:^(download)$"
      "float, class:^(notification)$"
      "float, class:^(error)$"
      "float, class:^(splash)$"
      "float, class:^(confirmreset)$"

      #
      # Fixes
      #

      # Jetbrains
      "windowdance, class:^(jetbrains-.*)$,floating:1"
      "center, class:^(jetbrains-.*)$,title:^(splash)$,floating:1"
      "nofocus, class:^(jetbrains-.*)$,title:^(splash)$,floating:1"
      "noborder, class:^(jetbrains-.*)$,title:^(splash)$,floating:1"
      "center, class:^(jetbrains-.*)$,title:^( )$,floating:1"
      "stayfocused, class:^(jetbrains-.*)$,title:^( )$,floating:1"
      "noborder, class:^(jetbrains-.*)$,title:^( )$,floating:1"
      "nofocus, class:^(jetbrains-.*)$,title:^(win.*)$,floating:1"
      "noinitialfocus, class:^(jetbrains-.*)$,title:^(win.*)$"
    ];

    layerrule = [
      # Don't add borders to grim selections when taking screenshots
      "noanim, ^(selection)$"
    ];
  };
}


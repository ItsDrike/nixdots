{
  config,
  ...
}:
{
  wayland.windowManager.hyprland.settings = {

    #
    # Window gaps
    #

    general = {
      gaps_in = 5;
      gaps_out = 8;
    };

    #
    # Borders
    #

    decoration.rounding = 8;

    general = {
      border_size = 2;

      # Regular windows
      "col.active_border" = "rgba(FFA500FF)"; # orange
      "col.inactive_border" = "rgba(666666AA)"; # transparent gray

      # Windows with nogroup property
      "col.nogroup_border_active" = "rgba(FF00FFFF)"; # purple
      "col.nogroup_border" = "rgba(FF00FFAA)"; # transparent purple
    };

    group = {
      # Groupped windows
      "col.border_active" = "rgba(00A500FF)";  # green
      "col.border_inactive" = "rgba(5AA500FF)";  # transparent green

      # Locked groupped windows
      "col.border_locked_active" = "rgba(A0A500FF)";  # yellow
      "col.border_locked_inactive" = "rgba(A0A500AA)";  # transparent yellow
    };

    #
    # Group bar
    #

    group = {
      groupbar = {
        # Title box above window
        render_titles = false; # disable, looks kinda bad
        font_family = "Monaspace Krypton";
        font_size = 11;
        text_color = "rgba(FFFFFFFF)";  # white

        # Gradients should be enabled only if title rendering is also enabled
        # on their own, they look really bad
        gradients = false;

        "col.active" = "rgba(FFA500FF)"; # light orange
        "col.inactive" = "rgba(00A500AA)"; # transparent green

        "col.locked_active" = "rgba(FF8000FF)"; # dark orange
        "col.locked_inactive" = "rgba(A0A500AA)"; # transparent yello

        # Scrolling in the groupbar shouldn't change the active window
        scrolling = false;
      };
    };

    #
    # Drop shadow
    #

    decoration = {
      drop_shadow = true;
      shadow_range = 20;
      shadow_render_power = 2;
      "col.shadow" = "rgba(0F0F0FE6)";
      "col.shadow_inactive" = "rgba(0F0F0F99)";
    };


    #
    # Window Blur
    #

    decoration.blur = {
      enabled = true;
      size = 8;
      passes = 1;
    };


    #
    # Dim inactive windows
    #

    decoration = {
      dim_inactive = false; # disabled for now
      dim_strength = 0.05;
      dim_special = 0.2;
      inactive_opacity = 0.9;
    };

    #
    # Animation
    #
    
    animations = {
      enabled = true;
      first_launch_animation = true; # fade in on first launch

      animation = [
        "windows, 1, 3, default, popin 50%"
        "border, 1, 4, default"
        "fade, 1, 4, default"
        "workspaces, 1, 3, default"
        "specialWorkspace, 1, 2, default, slidefadevert"
      ];
    };

    misc.animate_manual_resizes = true;
  };
}


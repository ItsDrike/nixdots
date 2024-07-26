{
  wayland.windowManager.hyprland.settings = {
    misc = {
      # Disable redundant renders (covered by wallpaper)
      disable_hyprland_logo = true;
      disable_splash_rendering = true;

      # Follow requests from windows to be focused
      focus_on_activate = true;

      # Auto-reload is unnecessary on NixOS, config is readonly
      disable_autoreload = true;

      # Enable DPMS on these actions
      mouse_move_enables_dpms = true;
      key_press_enables_dpms = true;
    };
  };
}

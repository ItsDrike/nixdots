{
  wayland.windowManager.hyprland.settings = {
    input = {
      # Keyboard layout settings
      # Default to US keyboard, but allow switching to SK with alt-shift
      kb_layout = "us, sk";
      kb_variant = ",qwerty";
      kb_options = "grp:alt_shift_toggle";

      # Enable numlock by default (once Hyprland is loaded)
      numlock_by_default = true;

      # cursor movement will always change focus to the window under the cursor
      follow_mouse = 1;

      touchpad = {
        # Sending LMB + RMB = MMB
        middle_button_emulation = true;
        # I'm not natural
        natural_scroll = false;
      };
    };
  };
}


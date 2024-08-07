{
  wayland.windowManager.hyprland.settings = {
    general.layout = "dwindle";

    dwindle = {
      # Don't change the split (side/top) regardless of what happens to the container
      preserve_split = true;

      # Show gaps even when there's only 1 window opened
      no_gaps_when_only = false;

      # Scale down special workspaces (bigger borders)
      special_scale_factor = 0.9;
    };

    group = {
      # Add new windows in the group after the current window
      # rather than after the group tail window
      insert_after_current = true;

      # Focus the window that was just moved out of the group
      focus_removed_window = true;
    };
  };
}

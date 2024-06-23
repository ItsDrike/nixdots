{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP"
      "${pkgs.systemd}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=$XDG_CURRENT_DESKTOP"
    ];
  };
}

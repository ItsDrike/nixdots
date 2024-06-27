{pkgs, ...}: {
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GTK_THEME QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE"
      "${pkgs.systemd}/bin/dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP GTK_THEME QT_QPA_PLATFORMTHEME QT_STYLE_OVERRIDE"
    ];
  };
}

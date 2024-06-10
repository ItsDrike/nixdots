{pkgs, ...}:
  pkgs.writeShellScriptBin "hyprland-move-window" ''
    ${builtins.readFile ./hyprland-move-window.sh}
  ''


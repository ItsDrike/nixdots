{pkgs, ...}:
  pkgs.writeShellScriptBin "hyprland-swap-workspace" ''
    ${builtins.readFile ./hyprland-swap-workspace.sh}
  ''

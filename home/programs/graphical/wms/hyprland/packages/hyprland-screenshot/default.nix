# - `grim`: screenshot utility for wayland
# - `slurp`: to select an area
# - `hyprctl`: to read properties of current window
# - `wl-copy`: clipboard utility
# - `jq`: json utility to parse hyprctl output
# - `notify-send`: to show notifications
# - `swappy`: for editing the screenshots (only required for --edit)

{pkgs, ...}:
pkgs.writeShellApplication {
  name = "hyprland-screenshot";
  runtimeInputs = with pkgs; [
    jq
    grim
    slurp
    swappy
    wl-clipboard
    libnotify
    hyprland
  ];
  text = ''
    ${builtins.readFile ./hyprland-screenshot.sh}
  '';
}

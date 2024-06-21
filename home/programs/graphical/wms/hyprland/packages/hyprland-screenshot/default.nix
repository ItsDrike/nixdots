# - `grim`: screenshot utility for wayland
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

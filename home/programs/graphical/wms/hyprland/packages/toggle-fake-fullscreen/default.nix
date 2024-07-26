{pkgs, ...}:
pkgs.writeShellApplication {
  name = "toggle-fake-fullscreen";
  runtimeInputs = with pkgs; [
    coreutils
    jq
    hyprland
  ];
  text = ''
    ${builtins.readFile ./toggle-fake-fullscreen.sh}
  '';
}

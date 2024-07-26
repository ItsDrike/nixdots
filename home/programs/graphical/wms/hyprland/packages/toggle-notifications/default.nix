{pkgs, ...}:
pkgs.writeShellApplication {
  name = "toggle-notifications";
  runtimeInputs = with pkgs; [
    coreutils
    libnotify
    dunst
  ];
  text = ''
    ${builtins.readFile ./toggle-notifications.sh}
  '';
}

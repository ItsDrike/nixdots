{pkgs, ...}:
pkgs.writeShellApplication {
  name = "toggle-idle";
  runtimeInputs = with pkgs; [
    coreutils
    gnugrep
    procps
    libnotify
    hypridle
  ];
  text = ''
    ${builtins.readFile ./toggle-idle.sh}
  '';
}

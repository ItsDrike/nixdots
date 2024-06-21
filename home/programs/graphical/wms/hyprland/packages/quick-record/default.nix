{pkgs, ...}:
pkgs.writeShellApplication {
  name = "quick-record";
  runtimeInputs = with pkgs; [
    slurp
    wl-clipboard
    libnotify
    procps
    killall
    wf-recorder
  ];
  text = ''
    ${builtins.readFile ./quick-record.sh}
  '';
}


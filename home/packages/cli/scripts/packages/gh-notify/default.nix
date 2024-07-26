{pkgs, ...}: (pkgs.writeShellApplication {
  name = "gh-notify";
  runtimeInputs = with pkgs; [
    coreutils
    findutils
    gawk
    libnotify
    gh # we also need gh-notify plugin, this assumes it's installed
  ];
  text = ''
    ${builtins.readFile ./gh-notify.sh}
  '';
})

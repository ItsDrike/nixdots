{pkgs, ...}:
(pkgs.writeShellApplication {
  name = "unix";
  runtimeInputs = with pkgs; [coreutils];
  text = ''
    ${builtins.readFile ./unix.sh}
  '';
})



{pkgs, ...}:
(pkgs.writeShellApplication {
  name = "colors-256";
  runtimeInputs = with pkgs; [coreutils];
  text = ''
    ${builtins.readFile ./colors-256.sh}
  '';
})


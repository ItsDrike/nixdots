{pkgs, ...}:
(pkgs.writeShellApplication {
  name = "cheat.sh";
  runtimeInputs = with pkgs; [coreutils curl jq gnugrep fzf];
  text = ''
    ${builtins.readFile ./cheat.sh}
  '';
})

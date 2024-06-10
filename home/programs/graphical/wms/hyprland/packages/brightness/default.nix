{pkgs, ...}:
  pkgs.writeShellScriptBin "brightness" ''
    ${builtins.readFile ./brightness.sh}
  ''

{pkgs, ...}:
pkgs.writeShellScriptBin "better-git-branch" ''
  ${builtins.readFile ./better-git-branch.sh}
''

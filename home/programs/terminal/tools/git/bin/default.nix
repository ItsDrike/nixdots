{pkgs, ...}: let
  packages = {
    better-git-branch = pkgs.callPackage ./better-git-branch {};
  };
in
  packages

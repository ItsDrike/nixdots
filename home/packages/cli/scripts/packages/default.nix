{
  pkgs,
  ...
}: let
  packages = {
    bitcoin = pkgs.callPackage ./bitcoin.nix {};
    cheatsh = pkgs.callPackage ./cheatsh {};
  };
in
  packages


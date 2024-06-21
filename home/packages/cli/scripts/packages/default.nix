{
  pkgs,
  ...
}: let
  packages = {
    bitcoin = pkgs.callPackage ./bitcoin.nix {};
    cheatsh = pkgs.callPackage ./cheatsh {};
    colors256 = pkgs.callPackage ./colors256 {};
  };
in
  packages


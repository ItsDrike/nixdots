{
  pkgs,
  ...
}: let
  packages = {
    bitcoin = pkgs.callPackage ./bitcoin.nix {};
  };
in
  packages


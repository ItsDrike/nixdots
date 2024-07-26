{pkgs, ...}: let
  scriptPkgs = import ./packages {inherit pkgs;};
in {
  home.packages = with scriptPkgs; [
    bitcoin
    cheatsh
    colors256
    unix
    gh-notify
  ];
}

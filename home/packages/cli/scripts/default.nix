{
  pkgs,
  ...
}: let

  scriptPkgs = (import ./packages {inherit pkgs;});
in {
    home.packages = with scriptPkgs; [
      bitcoin
    ];
}

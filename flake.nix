{
  description = "ItsDrike's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = {self, nixpkgs, ...} @ inputs: let
  in {
    nixosConfigurations = import ./hosts {inherit nixpkgs inputs self;};
  };
}

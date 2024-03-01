{
  description = "ItsDrike's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {self, nixpkgs, ...} @ inputs: let
  in {
    nixosConfigurations = import ./hosts {inherit nixpkgs inputs self;};
  };
}

{
  description = "ItsDrike's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # doesn't offer much above properly used symlinks but it is convenient
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = {self, nixpkgs, ...} @ inputs: let
  in {
    nixosConfigurations = import ./hosts {inherit nixpkgs inputs self;};
  };
}

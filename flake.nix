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

    # secure-boot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Spotify + themes
    spicetify = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Sandbox wrappers for programs
    nixpak = {
      url = "github:nixpak/nixpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Schizophrenic Firefox
    schizofox = {
      url = "github:schizofox/schizofox";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };

    # Application launcher
    walker = {
      url = "github:abenz1267/walker";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs = {self, nixpkgs, ...} @ inputs: {
    nixosConfigurations = import ./hosts {inherit inputs;};
    devShells = import ./shells {inherit inputs;};
  };
}

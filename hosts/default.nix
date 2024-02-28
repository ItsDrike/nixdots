{self, inputs, ...}: {
  flake.nixosConfigurations = let
    inherit (inputs.nixpkgs.lib) nixosSystem;
    specialArgs = {inherit inputs self;};
  in {
    vboxnix = nixosSystem {
      inherit specialArgs;
      modules = [ ../system ./vbox_nix ];
    };
  };
}

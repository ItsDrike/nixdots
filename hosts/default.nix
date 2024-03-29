{ self, inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;

  # A list of shared modules that ALL systems need
  shared = [
    ../system
    ../home
    ../options
  ];
in
{
  vboxnix = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./vbox_nix
      inputs.home-manager.nixosModules.home-manager
    ] ++ shared;
  };
}

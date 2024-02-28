{self, inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  vboxnix = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [ ../system ./vbox_nix ];
  };
}

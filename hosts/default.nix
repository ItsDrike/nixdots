{self, inputs, ...}: let
  inherit (inputs.nixpkgs) lib;
in {
  vboxnix = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./vbox_nix
      ../system
      ../system/options/systemd-boot.nix
      ../system/options/cachix.nix
      ../system/options/oomd.nix
      ../modules/services/ssh.nix
      inputs.home-manager.nixosModules.home-manager
    ];
  };
}

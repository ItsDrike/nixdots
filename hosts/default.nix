{inputs, ...}: let
  inherit (inputs) self;
  inherit (inputs.nixpkgs) lib;

  # A list of shared modules that ALL systems need
  shared = [
    ../system/shared
    ../home
    ../options
  ];

  workstationRole = ../system/roles/workstation;
  laptopRole = ../system/roles/laptop;
  uniRole = ../system/roles/uni;
in {
  herugrim = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit lib inputs self;};
    modules =
      [
        ./herugrim
        inputs.home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
        inputs.lanzaboote.nixosModules.lanzaboote
        workstationRole
        laptopRole
      ]
      ++ shared;
  };

  voyager = lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {inherit lib inputs self;};
    modules =
      [
        ./voyager
        inputs.home-manager.nixosModules.home-manager
        inputs.impermanence.nixosModules.impermanence
        inputs.lanzaboote.nixosModules.lanzaboote
        workstationRole
        laptopRole
        uniRole
      ]
      ++ shared;
  };
}

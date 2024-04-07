{ inputs, ... }:
{
  imports = [
    inputs.impermanence.nixosModules.impermanence
    ./root.nix
  ];
}

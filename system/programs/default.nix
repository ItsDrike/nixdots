{ pkgs, lib, ... }: {
  imports = [
    ./nano.nix
  ];

  # Basic list of must-have packages for all systems
  environment.systemPackages = with pkgs; [
    vim
  ];
}

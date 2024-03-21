{ pkgs, lib, ... }: {
  imports = [
    ./nano.nix
  ];

  # Basic list of must-have packages for all systems
  # TODO: Move these to home-manager, no need for system wide deps
  # although maybe keep vim
  environment.systemPackages = with pkgs; [
    vim
    gnupg
    delta
  ];
}

{ lib, pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  nix.settings = {
    max-jobs = 6;
    cores = 6;
  };

  security.sudo.package = pkgs.sudo.override { withInsults = true; };
  security.polkit.enable = true;
  services = {
    udisks2.enable = true;
  };

  # NixOS release from which this machine was first installed.
  # (for stateful data, like file locations and db versions)
  # Leave this alone!
  system.stateVersion = lib.mkForce "23.11";

  myOptions = {
    system = {
      hostname = "vboxnix";
      username = "itsdrike";
    };
    device = {
      type = "desktop";
      virtual-machine = true;
      cpu.type = "amd";
    };
    home-manager = {
      enable = true;
      stateVersion = "23.11";
      git = {
        userName = "ItsDrike";
        userEmail = "itsdrike@protonmail.com";
        signing.key = "FA2745890B7048C0";
      };
    };
  };
}

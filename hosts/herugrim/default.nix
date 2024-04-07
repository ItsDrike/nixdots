{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./impermanence.nix
  ];

  boot.supportedFilesystems = [ "btrfs" ];

  nix.settings = {
    max-jobs = 6;
    cores = 6;
  };

  # NixOS release from which this machine was first installed.
  # (for stateful data, like file locations and db versions)
  # Leave this alone!
  system.stateVersion = lib.mkForce "23.11";

  services.openssh.settings.PasswordAuthentication = lib.mkForce true;

  myOptions = {
    system = {
      hostname = "herugrim";
      username = "itsdrike";
    };
    device = {
      virtual-machine = false;
      cpu.type = "intel";
    };
    home-manager = {
      enabled = true;
      stateVersion = "23.11";
      git = {
        userName = "ItsDrike";
        userEmail = "itsdrike@protonmail.com";
        signing = {
          enabled = true;
          key = "FA2745890B7048C0";
        };
      };
    };
  };
}

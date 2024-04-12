{ config, pkgs, lib, ... }: let
  inherit (lib) mkIf;

  cfg = config.myOptions.system.secure-boot;
in {
  config = mkIf cfg.enabled {
    # Secure Boot Key Manager
    environment.systemPackages = [ pkgs.sbctl ];

    # Persist the secure boot keys (for impermanence)
    myOptions.system.impermanence.root.extraDirectories = [
      "/etc/secureboot"
    ];

    # Lanzaboote replaces systemd-boot
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
  };
}

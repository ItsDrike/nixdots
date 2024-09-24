{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf optional;

  cfg = config.myOptions.workstation.printing;
  cfgUser = config.myOptions.system.username;
in {
  config = mkIf cfg.enable {
    # enable cups and add some drivers for common printers
    services = {
      printing = {
        enable = true;
        drivers = with pkgs; [
          gutenprint
          hplip
        ];
      };

      # required for network discovery of printers
      avahi = {
        enable = true;
        # resolve .local domains for printers
        nssmdns4 = true;
        # open the avahi port(s) in the firewall
        openFirewall = true;
      };
    };

    environment.systemPackages = optional cfg.hplip.enable pkgs.hplip;
    myOptions.system.impermanence.home.extraDirectories = optional cfg.hplip.enable ".hplip";

    # Support for SANE (Scanner Access Now Easy) scanners
    hardware.sane = {
      enable = true;
      extraBackends = optional cfg.hplip.enable pkgs.hplipWithPlugin;
    };

    users.extraGroups.scanner.members = ["${cfgUser}"];
    users.extraGroups.lp.members = ["${cfgUser}"];
  };
}

{ pkgs, lib, config, ...}: let
  inherit (lib) mkIf;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];

  cfg = config.myOptions.workstation.printing;
in {

  config = mkIf (builtins.elem deviceType acceptedTypes && cfg.enable) {
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
  };
}

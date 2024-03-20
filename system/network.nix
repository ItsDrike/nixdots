{ lib, ... }:
{
  networking = {
    firewall.enable = false;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services.resolved = {
    enable = true;
    fallbackDns = [
      "9.9.9.9"
      "2620:fe::fe"
    ];
  };
}

{lib, ...}:
{
  networking = {
    firewall.enable = false;

    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
  };

  services.resolved.enable = true;
}

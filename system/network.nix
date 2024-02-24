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

  # Don't wait for network manager startup
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;
}

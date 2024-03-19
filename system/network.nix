{lib, ...}:
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

  # don't wait for network to boot faster
  # https://old.reddit.com/r/NixOS/comments/vdz86j/how_to_remove_boot_dependency_on_network_for_a
  systemd = {
      targets.network-online.wantedBy = lib.mkForce []; # default is [ "multi-user.target" ]
      services.NetworkManager-wait-online.wantedBy = lib.mkForce []; # default is [ "network-online.target" ]
  };
}

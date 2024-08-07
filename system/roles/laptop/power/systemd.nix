{
  # /etc/systemd/sleep.conf
  systemd.sleep.extraConfig = ''
    # Configure `systemctl suspend-then-sleep` to enter hibernation after 3 hours of sleep.
    HibernateDelaySec=10800
  '';
}

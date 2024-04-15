{
  # Limit systemd journal size, as the default is unlimited and
  # journals get big really fast
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    RuntimeMaxUse=50M
    SystemMaxFileSize=50M
  '';
}

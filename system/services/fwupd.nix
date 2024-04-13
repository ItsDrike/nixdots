{config, ...}: {
  # firmware updater for machine hardware
  services.fwupd = {
    enbale = true;
    daemonSettings.EspLocation = config.boot.loader.efi.efiSysMountPoint;    
  };
}

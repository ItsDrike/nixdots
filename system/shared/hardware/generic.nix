{lib, ...}: {
  # This enables non-free firmware on devices not recognized by `nixos-generate-config`.
  # Disabling this option will make the system unbootable if such devices are critical
  # in your boot chain - therefore this should remain true until you are running a device
  # with mostly libre firmware. Which there is not many of.
  # Without this, it defaults to `config.hardware.enableAllFirmware`.
  hardware.enableRedistributableFirmware = lib.mkDefault true;
}

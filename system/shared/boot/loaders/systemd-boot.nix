{
  config,
  lib,
  ...
}: let
  cfg = config.myOptions.system.boot;
in {
  boot.loader.systemd-boot = {
    enable = true;
    memtest86.enable = true;

    # Enabling the editor will allow anyone to change the kernel params.
    # This can be useful for debugging, however it is a potential security hole
    # as this allows setting init=/bin/bash, which will boot directly into bash
    # as root, bypassing any need for authentication.
    #
    # If you're using an encrypted setup, and you can't get into the system without
    # entering a decryption password (or have TPM release it conditionally, only if
    # the kernel parameters remain the same), this can safely be enabled.
    editor = lib.mkDefault false;
  };
}

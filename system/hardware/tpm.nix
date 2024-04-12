{ config, lib, pkgs, ... }: let
  inherit (lib) mkIf mkDefault;

  enabled = config.myOptions.device.hasTPM;
in {
  config = mkIf enabled {
    security.tpm2 = {
      # enable Trusted Platform Module 2 support
      enable = true;

      # enable Trusted Platform 2 userspace resource manager daemon
      abrmd.enable = mkDefault false;

      # The TCTI is the "Transmission Interface" that is used to communicate with a
      # TPM. this option sets TCTI environment variables to the specified values if enabled
      #  - TPM2TOOLS_TCTI
      #  - TPM2_PKCS11_TCTI
      tctiEnvironment.enable = mkDefault true;

      # enable TPM2 PKCS#11 tool and shared library in system path
      pkcs11.enable = mkDefault false;
    };

    environment.systemPackages = with pkgs; [ tpm2-tss tpm2-tools ];
  };
}

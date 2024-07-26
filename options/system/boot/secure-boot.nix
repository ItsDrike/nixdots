{lib, ...}:
with lib; let
  inherit (lib) mkEnableOption;
in {
  options.myOptions.system.boot.secure-boot = {
    enable = mkEnableOption ''
      secure-boot using lanzaboote.

      Note that you will need to have UEFI firmware, and the rebuild
      will report errors until you generate the secure boot keys with:
      ```shell
      sudo sbctl create-keys
      ````

      Optionally (though enabling this is pointless otherwise), you should
      now enter secure-boot setup mode and enroll the keys:
      ```shell
      sudo sbctl enroll-keys -m
      ```
      Then reboot, and secure-boot should be enabled.
    '';
  };
}

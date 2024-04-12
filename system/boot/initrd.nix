{pkgs, ...}: {
  boot.initrd = {
    systemd = {
      # Enable systemd in initrd
      # I prefe to use systemd in initrd, because it is more powerful than busybox
      # however, it can result in slightly slower boot times.
      enable = true;

      # Strip copied binaries and libraries from initrd
      # saves 30~ MB of space, according to the nix derivation
      strip = true;

      # Packages to include in the initrd
      # This is useful for debugging, if the host provides
      # emergency mode
      storePaths = with pkgs; [util-linux pciutils];
      extraBin = {
        fdisk = "${pkgs.util-linux}/bin/fdisk";
        lsblk = "${pkgs.util-linux}/bin/lsblk";
        lspci = "${pkgs.pciutils}/bin/lspci";
      };
    };
  };
}

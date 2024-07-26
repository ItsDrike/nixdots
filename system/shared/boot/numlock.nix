{pkgs, ...}: {
  boot.initrd.systemd = {
    # Include setleds binary in the initrd
    # (the nix store doesn't exists in there yet, so we need to include
    # all of the necessary binaries ahead of time here)
    extraBin = {
      setleds = "${pkgs.kbd}/bin/setleds";
    };

    # Enable numlock in the early userspace (initrd)
    # This will happen before we're asked for the disk decryption password
    services."numlock" = {
      enable = true;
      description = "Activate Numlock";
      wantedBy = ["initrd.target"];
      # Delay disk decryption until this unit is started
      before = ["systemd-cryptsetup@cryptfs.service"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      # This is essentially runs the same code as present in the
      # mkinitcpio-numlock hook on Arch Linux (AUR).
      script = ''
        #!/bin/bash

        for tty in /dev/tty{1..6}
        do
            /bin/setleds -D +num < "$tty";
        done
      '';
    };
  };
}

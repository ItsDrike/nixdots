_: {
    boot.loader = {
        systemd-boot = {
            enable = true;
            memtest86.enable = true;
            editor = true;
        };
        efi.canTouchEfiVariables = true;
        timeout = 3;
    };
}


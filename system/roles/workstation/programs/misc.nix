{
  programs = {
    # allow non-root users to mount fuse filesystems with allow_other
    fuse.userAllowOther = true;

    # show network usage
    bandwhich.enable = true;

    # network inspection utility
    wireshark.enable = true;

    # gnome's keyring manager
    seahorse.enable = true;

    # registry for linux (thanks to Gnome)
    dconf.enable = true;
  };
}

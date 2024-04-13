{ config, ... }:
{
  services = {
    # enable GVfs, a userspace virtual filesystem
    # (allows viewing ftp,sftp,... directly from the file manager)
    gvfs.enable = true;

    # Storage daemon required for udiskie auto-mount
    udisks2.enable = !config.boot.isContainer;
  };
}

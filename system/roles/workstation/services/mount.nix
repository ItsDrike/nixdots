{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    services = {
      # enable GVfs, a userspace virtual filesystem
      # (allows viewing ftp,sftp,... directly from the file manager)
      gvfs.enable = true;

      # Storage daemon required for udiskie auto-mount
      udisks2.enable = !config.boot.isContainer;
    };
  };
}

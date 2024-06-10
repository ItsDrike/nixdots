{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    services = {
      # enable GVfs - a userspace virtual filesystem
      gvfs.enable = true;

      # storage daemon required for udiskie auto-mount
      udisks2.enable = true;
    };
  };
}

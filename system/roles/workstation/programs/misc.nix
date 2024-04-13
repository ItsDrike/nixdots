{ lib, config, ...}: let
  inherit (lib) mkIf;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    programs = {
      # allow non-root users to mount fuse filesystems with allow_other
      fuse.userAllowOther = true;

      # show network usage
      bandwhich.enable = true;

      # network inspection utility
      wireshark.enable = true;

      # gnome's keyring manager
      seahorse.enable = true;
    };
  };
}

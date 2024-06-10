{ lib, config, ...}: let
  inherit (lib) mkIf;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    # Screen locker which works across all virtual terminals
    # Use `systemctl start physlock` to securely lock the screen
    services.physlock = {
      enable = true;
      lockMessage = "System is locked...";
    };
  };
}

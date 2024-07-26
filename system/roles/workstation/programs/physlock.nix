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
    # Screen locker which works across all virtual terminals
    # Use `systemctl start physlock` to securely lock the screen
    services.physlock = {
      enable = true;
      lockMessage = "System is locked...";

      # Don't auto-lock the system with physlock, I prefer other (gui) lockers
      # I only use physlock manually in some circumstances
      lockOn = {
        suspend = false;
        hibernate = false;
      };
    };
  };
}

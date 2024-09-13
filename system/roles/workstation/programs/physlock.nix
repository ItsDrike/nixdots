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

      # I only use physlock manually in some circumstances
      lockOn = {
        # Don't auto-lock the system with physlock on suspend, I prefer other (gui) lockers
        suspend = false;
        # Do use physlock on resuming from hibernation though, as this just restored RAM,
        # potentially bypassing the login screen and even initial disk encryption password
        hibernate = true;
      };
    };
  };
}

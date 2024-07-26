{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop"];
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    services.libinput = {
      # enable libinput
      enable = true;

      # disable mouse acceleration
      mouse = {
        accelProfile = "flat";
        accelSpeed = "0";
        middleEmulation = false;
      };

      # touchpad settings
      touchpad = {
        naturalScrolling = false; # I'm not natural
        tapping = true;
        clickMethod = "clickfinger";
        horizontalScrolling = true;
        disableWhileTyping = true;
      };
    };
  };
}

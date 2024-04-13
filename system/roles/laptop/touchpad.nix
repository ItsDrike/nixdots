{
  services.xserver.libinput = {
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
      naturalScrolling = false; # I'm weird like that
      tapping = true;
      clickMethod = "clickfinger";
      horizontalScrolling = true;
      disableWhileTyping = true;
    };
  };
}

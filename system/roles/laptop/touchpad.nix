{
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
}

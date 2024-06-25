{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (lib.strings) concatStringsSep;


  deviceType = config.myOptions.device.roles.type;
  acceptedTypes = ["laptop" "desktop"];

  greetingMsg = "'Access is restricted to authorized personnel only.'";
  tuiGreetTheme = "'border=magenta;text=cyan;prompt=green;time=red;action=white;button=yellow;container=black;input=gray'";

  sessionData = config.services.displayManager.sessionData.desktops;
  sessionPaths = concatStringsSep ":" [
    "${sessionData}/share/xsessions"
    "${sessionData}/share/wayland-sessions"
  ];

  defaultSession = {
    user = "greeter";
    command = concatStringsSep " " [
      (getExe pkgs.greetd.tuigreet)
      "--time"
      "--remember"
      "--remember-user-session"
      "--asterisks"
      "--greeting ${greetingMsg}"
      "--sessions '${sessionPaths}'"
      "--theme ${tuiGreetTheme}"
    ];
  };
in {
  config = mkIf (builtins.elem deviceType acceptedTypes) {
    services.greetd = {
      enable = true;
      vt = 1;

      # <https://man.sr.ht/~kennylevinsen/greetd/>
      settings = {
        # default session is what will be used if no session is selected
        # in this case it'll be a TUI greeter
        default_session = defaultSession;
      };
    };

    # Suppress error messages on tuigreet. They sometimes obscure the TUI
    # boundaries of the greeter.
    # See: https://github.com/apognu/tuigreet/issues/68#issuecomment-1586359960
    systemd.services.greetd.serviceConfig = {
      Type = "idle";
      StandardInputs = "tty";
      StandardOutput = "tty";
      StandardError = "journal";
      TTYReset = true;
      TTYVHangup = true;
      TTYVTDisallocate = true;
    };

    # Persist info about previous session & user
    myOptions.system.impermanence.root.extraDirectories = [ "/var/cache/tuigreet" ];
  };
}

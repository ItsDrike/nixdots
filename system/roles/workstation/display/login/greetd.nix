{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
  inherit (lib.strings) concatStringsSep;

  greetingMsg = "'Access is restricted to authorized personnel only.'";
  tuiGreetTheme = "'border=magenta;text=cyan;prompt=green;time=red;action=white;button=yellow;container=black;input=gray'";

  sessionData = config.services.displayManager.sessionData.desktops;

  # Run the session / application using the appropriate shell configured for this user.
  # This will make sure all of the environment variables are set before the WM session
  # is started. This is very important, as without it, variables for things like qt theme
  # will not be set, and applications executed by the WM will not be themed properly.
  sessionWrapperScript = pkgs.writeShellScriptBin "tuigreet-session-wrapper" ''
    set -euo pipefail

    script_name="$0"
    shell="$(getent passwd itsdrike | awk -F: '{print $NF}')"
    command=("$@")

    exec "$shell" -c 'exec "$@"' "$script_name" "''${command[@]}"
  '';

  defaultSession = {
    user = "greeter";
    command = concatStringsSep " " [
      (getExe pkgs.greetd.tuigreet)
      "--time"
      "--remember"
      "--remember-user-session"
      "--asterisks"
      "--greeting ${greetingMsg}"
      "--theme ${tuiGreetTheme}"
      "--sessions '${sessionData}/share/wayland-sessions'"
      "--xsessions '${sessionData}/share/xsessions'"
      "--session-wrapper ${sessionWrapperScript}/bin/tuigreet-session-wrapper"
      "--xsession-wrapper ${sessionWrapperScript}/bin/tuigreet-session-wrapper startx /usr/bin/env"
    ];
  };
in {
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
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  # Persist info about previous session & user
  myOptions.system.impermanence.root.extraDirectories = ["/var/cache/tuigreet"];
}

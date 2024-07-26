{
  config,
  lib,
  ...
}: {
  security.polkit = {
    enable = true;
    debug = lib.mkDefault true;

    # Have polkit log all actions, if debug is enabled
    extraConfig = lib.mkIf config.security.polkit.debug ''
      /* Log authorization checks. */
      polkit.addRule(function(action, subject) {
        polkit.log("user " +  subject.user + " is attempting action " + action.id + " from PID " + subject.pid);
      });
    '';
  };
}

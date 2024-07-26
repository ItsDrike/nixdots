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
    # unlock GPG keyring on login
    security.pam.services = let
      gnupg = {
        enable = true;
        noAutostart = true;
        storeOnly = true;
      };
    in {
      login = {
        enableGnomeKeyring = true;
        inherit gnupg;
      };

      greetd = {
        enableGnomeKeyring = true;
        inherit gnupg;
      };

      tuigreet = {
        enableGnomeKeyring = true;
        inherit gnupg;
      };
    };
  };
}

{
  config,
  pkgs,
  ...
}: {
  services.dbus.apparmor = "enabled";

  environment.systemPackages = with pkgs; [
    apparmor-pam
    apparmor-utils
    apparmor-parser
    apparmor-profiles
    apparmor-bin-utils
    apparmor-kernel-patches
    libapparmor
  ];

  # apparmor configuration
  security.apparmor = {
    enable = true;

    # whether to enable AppArmor cache
    # in /var/cache/apparmor
    enableCache = true;

    # whether to kill processes which have an AppArmor profile enabled
    # but are not confined (AppArmor can only confine new processes)
    killUnconfinedConfinables = true;

    # packages to be added to AppArmor's include path
    packages = [pkgs.apparmor-profiles];

    # AppArmor policies
    policies = {
      "default_deny" = {
        enforce = false;
        enable = false;
        profile = ''
          profile default_deny /** {}
        '';
      };

      "sudo" = {
        enforce = false;
        enable = false;
        profile = ''
          ${pkgs.sudo}/bin/sudo {
            file /** rwlkUx
          }
        '';
      };

      "nix" = {
        enforce = false;
        enable = false;
        profile = ''
          ${config.nix.package}/bin/nix {
            unconfined
          }
        '';
      };
    };
  };
}

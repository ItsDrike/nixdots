{
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption types;

  cfg = config.myOptions.device.roles;
in {
  options.myOptions.device.roles = {
    type = mkOption {
      type = types.enum ["laptop" "desktop" "server"];
      default = "";
      description = ''
        The type/purpoes of the device that will be used within the rest of the configuration.
          - laptop: portable devices with battery optimizations
          - desktop: stationary devices configured for maximum performance
          - server: server and infrastructure
      '';
    };

    virtual-machine = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is this system a virtual machine?";
    };

    isWorkstation = mkOption {
      type = lib.types.bool;
      default = builtins.elem cfg.type ["laptop" "desktop"];
      readOnly = true;
      description = ''
        Is this machine a workstation?

        Workstation machines are meant for regular day-to-day use.
      '';
    };
  };
}

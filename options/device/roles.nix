{lib, ...}: let
  inherit (lib) mkOption;
in {
  options.myOptions.device.roles = {
    virtual-machine = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is this system a virtual machine?";
    };
  };
}

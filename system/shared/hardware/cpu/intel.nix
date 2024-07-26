{
  config,
  lib,
  ...
}: let
  dev = config.myOptions.device;
in {
  config = lib.mkIf (dev.cpu.type == "intel") {
    hardware.cpu.intel.updateMicrocode = true;
  };
}

{ config, lib, ... }:
let
  dev = config.myOptions.device;
in
{
  config = lib.mkIf (dev.cpu.type == "amd") {
    hardware.cpu.amd.updateMicrocode = true;
  };
}

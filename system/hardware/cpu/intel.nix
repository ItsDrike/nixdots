{ config, lib, ... }:
let
  dev = config.myOptions.device;
in
{
  config = lib.mkIf (builtins.elem dev.cpu.type [ "intel" "vm-intel" ]) {
    hardware.cpu.intel.updateMicrocode = true;
  };
}

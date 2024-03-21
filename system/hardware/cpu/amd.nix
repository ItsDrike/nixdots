{ config, lib, ... }:
let
  dev = config.myOptions.device;
in
{
  config = lib.mkIf (builtins.elem dev.cpu.type [ "amd" "vm-amd" ]) {
    hardware.cpu.amd.updateMicrocode = true;
  };
}

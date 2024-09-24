{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.myOptions.device.roles) isUniMachine;
in {
  config = mkIf isUniMachine {
    environment.systemPackages = [pkgs.android-studio];
  };
}

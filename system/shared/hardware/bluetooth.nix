{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.myOptions.device.bluetooth;
in {
  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      powerOnBoot = cfg.powerOnBoot;
      #hsphfpd.enable = true;
      disabledPlugins = ["sap"];
      settings = {
        General = {
          JustWorksRepairing = "always";
          MultiProfile = "multiple";
          Experimental = true;
        };
      };
    };

    # https://nixos.wiki/wiki/Bluetooth
    services.blueman.enable = true;
  };
}

{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  sys = config.myOptions.system.bluetooth;
in {
  config = mkIf sys.enable {
    hardware.bluetooth = {
      enable = true;
      package = pkgs.bluez5-experimental;
      #hsphfpd.enable = true;
      powerOnBoot = true;
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

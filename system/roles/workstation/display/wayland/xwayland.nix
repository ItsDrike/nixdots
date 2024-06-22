{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;

  cfgEnabled = config.myOptions.home-manager.wms.isWayland;
in {
  config = mkIf cfgEnabled {
    programs.xwayland.enable = true;
  };
}

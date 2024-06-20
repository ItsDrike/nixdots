{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
in {
  config = mkIf osConfig.myOptions.home-manager.wms.isWayland {
    home.packages = with pkgs; [
      wl-clipboard
    ];
  };
}

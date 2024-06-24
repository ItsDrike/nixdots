{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

in {
  config = mkIf osConfig.myOptions.home-manager.wms.isWayland {
    home.packages = with pkgs; [ wlogout ];
  };
}



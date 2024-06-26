{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.coding.python;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ pyright ];
  };
}

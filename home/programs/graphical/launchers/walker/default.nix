{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.myOptions.home-manager.programs.launchers.walker;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      walker
    ];

    xdg.configFile = {
      "walker/config.json".source = ./config.json;
      "walker/style.css".source = ./style.css;
    };
  };
}

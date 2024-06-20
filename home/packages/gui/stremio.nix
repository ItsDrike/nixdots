{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.stremio;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      stremio
    ];
  };
}


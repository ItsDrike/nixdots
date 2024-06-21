{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.obs;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      obs-studio
      obs-cli
    ];
  };
}



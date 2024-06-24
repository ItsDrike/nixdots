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
    programs.obs-studio.enable = true;

    home.packages = with pkgs; [
      obs-cli
    ];
  };
}




{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.mpv;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpv
    ];
  };
}


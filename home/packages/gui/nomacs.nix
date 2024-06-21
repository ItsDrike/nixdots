{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.nomacs;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nomacs
    ];
  };
}

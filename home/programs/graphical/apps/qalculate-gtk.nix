{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.qalculate-gtk;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ qalculate-gtk ];
  };
}

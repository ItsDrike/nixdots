{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.games.prismlauncher;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [prismlauncher];
  };
}

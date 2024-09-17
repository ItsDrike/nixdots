{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.games.lutris;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      (lutris.override {
        extraLibraries = pkgs: [
          pixman
        ];
        extraPkgs = pkgs: [
          jdk
        ];
      })
    ];
  };
}

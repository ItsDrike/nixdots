{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.browsers.mullvad-browser;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mullvad-browser
    ];
  };
}

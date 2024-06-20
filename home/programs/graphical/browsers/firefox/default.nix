{
  lib,
  osConfig,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.browsers.firefox;
in {
  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      # TODO: Finish this
    };
  };
}

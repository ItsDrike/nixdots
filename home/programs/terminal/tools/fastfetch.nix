{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.tools.fastfetch;
in {
  config = mkIf cfg.enable {
    programs.fastfetch.enable = true;
  };
}


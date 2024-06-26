{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.coding.python;
in {
  config = mkIf cfg.enable {
    programs.poetry = {
      enable = true;

      settings = {
        virtualenvs = {
          in-project = true;
          prefer-active-python = true;
        };
      };
    };
  };
}

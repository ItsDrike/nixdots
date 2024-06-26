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

          # use python the version of python that's globally installed on the system
          # and exists in PATH, instead of the python version poetry was installed
          # with. Annoyingly, there's no good way to override the python version at
          # which NixOS will built poetry here, so this is the next best thing.
          prefer-active-python = true;
        };
      };
    };
  };
}

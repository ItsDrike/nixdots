{
  inputs,
  config,
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.myOptions.home-manager.programs.launchers.walker;
in {
  imports = [inputs.walker.homeManagerModules.default];
  config = mkIf cfg.enable {
    programs.walker = {
      enable = true;
      runAsService = true; # makes walker a lot faster when starting

      config = lib.importJSON ./config.json;
      theme = {
        layout = lib.importJSON ./layout.json;
        style = builtins.readFile ./style.css;
      };
    };
  };
}

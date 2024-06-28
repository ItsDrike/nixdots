{
  inputs,
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.myOptions.home-manager.programs.launchers.walker;
in {
  imports = [ inputs.walker.homeManagerModules.walker ];
  config = mkIf cfg.enable {
    programs.walker = {
      enable = true;
      runAsService = true; # makes walker a lot faster when starting

      config = builtins.fromJSON (builtins.readFile ./config.json);
      style = builtins.readFile ./style.css;
    };
  };
}

{
  osConfig,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.myOptions.programs.launchers.wofi;
in: {
  config = mkIf cfg.enable {
    programs.wofi = {
      enable = true;
      settings = {
        width = "40%";
        height = "30%";
        show = "drun";
        prompt = "Search";
        allow_images = true;
        allow_markup = true;
        insensitive = true;
      };
      style = ''
        ${builtins.readFile ./style.css}
      '';
    };
  };
}

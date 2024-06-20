{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.tools.hyfetch;
in {
  config = mkIf cfg.enable {
    programs.hyfetch = {
      enable = true;
      settings = {
        preset = "rainbow";
        mode = "rgb";
        light_dark = "dark";
        lightness = 0.65;
        color_align = {
          mode = "custom";
          custom_colors = {};
          force_back = null;
        };
        backend = "neofetch";
        args = null;
        distro = null;
        pride_month_shown = [];
        pride_month_disable = true;
      };
    };
  };
}

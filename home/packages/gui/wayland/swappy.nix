# Swappy is an application for quick screenshot editing
{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

in {
  config = mkIf osConfig.myOptions.home-manager.wms.isWayland {
    home.packages = with pkgs; [ swappy ];

    xdg.configFile."swappy/config".text = lib.generators.toINI {} {
      General = {
        save_dir = "${config.xdg.userDirs.extraConfig.XDG_SCREENSHOTS_DIR}";
        save_filename_format = "Screenshot_%Y-%M-%d_%H-%M-%S.png";
        show_panel = false;
        line_size = 5;
        text_size = 20;
        text_font = "JetBrains Mono";
        early_exit = true;
        paint_mode = "rectangle";
      };
    };
  };
}

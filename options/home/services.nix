{lib, ...}:
with lib; let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.myOptions.home-manager.services = {
    dunst.enable = mkEnableOption "Dunst (lightweight notification daemon)";
    hyprpaper = {
      enable = mkEnableOption "Hyprpaper (Hyprland wallpaper daemon)";
      wallpaperPath = mkOption {
        type = types.path;
        default = null;
        description = "Path to the wallpaper of your choosing";
      };
    };
  };
}

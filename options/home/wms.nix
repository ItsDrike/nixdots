{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.myOptions.home-manager.wms = {
    hyprland = {
      enable = mkEnableOption ''
        Hyprland wayland compositor.
      '';

      monitor = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Monitor configuration.";
      };
    };

    isWayland = mkOption {
      type = types.bool;
      default = with config.myOptions.home-manager.wms; (hyprland.enable);
      description = ''
        Whether to enable Wayland exclusive modules, this contains a variety
        of packages, modules, overlays, XDG portals and so on.
      '';
    };
  };
}

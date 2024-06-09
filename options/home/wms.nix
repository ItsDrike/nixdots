{
  config,
  lib,
  ...
}: let
  inherit (lib) mkEnableOption mkOption types;
in {
  options.myOptions.home-manager.wms = {
    hyprland.enable = mkEnableOption ''
      Hyprland wayland compositor.
    '';

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

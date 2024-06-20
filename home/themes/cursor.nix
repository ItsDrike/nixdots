{
  osConfig,
  ...
}: let
  cfg = osConfig.myOptions.home-manager.theme.cursor;
in {
  home = {
    pointerCursor = {
      package = cfg.package;
      name = cfg.name;
      size = cfg.size;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}

{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.strings) optionalString;
in {
  home.packages = with pkgs; [
    ranger
  ];

  # TODO: more file preview methods
  xdg.configFile."ranger/rc.conf".text = ''
    set preview_images true
    ${(optionalString config.programs.kitty.enable "set preview_images_method kitty")}
  '';
}


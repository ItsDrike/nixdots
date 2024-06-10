{
  osConfig,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  devType = osConfig.myOptions.device.roles.type;
  acceptedTypes = [ "laptop" "desktop" ];
in {
  config = mkIf (builtins.elem devType acceptedTypes) {
    home.packages = with pkgs; [
      trash-cli
      bitwarden-cli
    ];
  };
}

{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf mkDefault;
  cfg = config.myOptions.system.sound;
in {
  imports = [ ./pipewire.nix ];
  config = mkIf cfg.enable {
    sound = {
      enable = mkDefault false; # this just enables ALSA, which we don't really care abouyt
      mediaKeys.enable = true;
    };
  };
}


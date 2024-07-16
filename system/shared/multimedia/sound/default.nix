{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.myOptions.system.sound;
in {
  imports = [./pipewire.nix];
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      # TUI tool to manage sound devices & levels
      # It's made for pulseaudio, but it will work with pipewire too since we
      # run a compatibility layer for pulse
      pulsemixer
    ];
  };
}

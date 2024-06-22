{
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.mpv;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      mpv
    ];

    xdg.configFile = {
      "mpv/mpv.conf".text = ''
        loop=yes
      '';

      "mpv/input.conf".text = ''
        # Vim keys seeking
        l seek 5
        h seek -5
        j seek -60
        k seek 60

        # Set A-B Loop key to g, since l was rebound
        g ab-loop

        # Swap i and I, use lowercase for toggle
        i script-binding stats/display-stats-toggle
        I script-binding stats/display-stats

        UP add volume 2
        DOWN add volume -2

        # Zooming
        -           add video-zoom -.25
        +           add video-zoom .25

        # Moving/panning video
        kp8         add video-pan-y .05
        kp6         add video-pan-x -.05
        kp2         add video-pan-y -.05
        kp4         add video-pan-x .05
        kp5         set video-pan-x 0; set video-pan-y 0; set video-zoom 0

        # Rotation
        ctrl+r      cycle_values video-rotate "90" "180" "270" "0"
      '';
    };
  };
}


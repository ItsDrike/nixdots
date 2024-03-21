{ lib, ... }: {
  systemd = {
    # OOMd: Out Of Memory daemon
    # By default, this will only kill cgroups. So either systemd services
    # marked for killing uder OOM or (non-default, but enabled here) the entire user slice.
    oomd = {
      enable = true;
      enableSystemSlice = true;
      enableRootSlice = true;
      enableUserSlices = true;
      extraConfig = {
        "DefaultMemoryPressureDurationSec" = "20s";
      };
    };

    # Make nix builds more likely to get killed than other important services.
    # The default for user slices is 100, and systemd-coredumpd is 500
    services.nix-daemon.serviceConfig.OOMScoreAdjust = lib.mkDefault 350;
  };
}

{
  lib,
  config,
  ...
}: let
  cfg = config.myOptions.system.docker;
in {
  config = lib.mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;
      storageDriver = "btrfs";

      daemon.settings.data-root = cfg.data-root;
    };
  };
}

{
  lib,
  osConfig,
  inputs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = osConfig.myOptions.system.impermanence.home;
in {
  imports = [inputs.impermanence.nixosModules.home-manager.impermanence];

  config = mkIf cfg.enable {
    home.persistence."${cfg.persistentMountPoint}" = {
      directories =
        [
          ".cache/nix"
          ".cache/nix-index"
        ]
        ++ cfg.extraDirectories;

      files =
        [
        ]
        ++ cfg.extraFiles;

      # Allow other users (such as root), to access files through the bind
      # mounted directories listed in `directories`. Useful for `sudo` operations,
      # Docker, etc. Requires NixOS configuration programs.fuse.userAllowOther = true;
      allowOther = true;
    };

    home.persistence."${cfg.persistentDataMountPoint}" = {
      directories =
        [
        ]
        ++ cfg.extraDataDirectories;

      files =
        [
        ]
        ++ cfg.extraDataFiles;

      # See comment for this above
      allowOther = true;
    };
  };
}

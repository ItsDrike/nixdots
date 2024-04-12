{ config, lib, ... }: let
  inherit (lib) mkDefault;

  cfg = config.myOptions.system.boot;
in {
  config.boot = {
    # kernel console loglevel
    consoleLogLevel = 3;

    # The NixOS default is to use an lts kernel, which can be quite old.
    # My configuration defaults to the latest kernel instead
    kernelPackages = cfg.kernel;

    loader = {
      # if set to 0, space needs to be held to get the boot menu to appear
      timeout = 2;

      # whether to copy the necessary boot files into /boot
      # so that /nix/store is not needed by the boot loader.
      generationsDir.copyKernels = true;

      # allow installation to modify EFI variables
      efi.canTouchEfiVariables = true;
    };

    tmp = {
      # /tmp on tmpfs, lets it live on your ram
      # it defaults to false, which means you will use disk space instead of ram 
      # enable tmpfs tmp on anything where you have ram to spare
      useTmpfs = cfg.tmpOnTmpfs;

      # if not using tmpfs, which is naturally purged on reboot, we must clean
      # /tmp ourselves. /tmp should be volatile storage!
      cleanOnBoot = mkDefault (!cfg.tmpOnTmpfs);

      # The size of the tmpfs, in percentage form
      # this defaults to 50% of your ram, which is a good default
      # but should be tweaked based on your systems capabilities
      tmpfsSize = mkDefault "50%";
    };
  };
}

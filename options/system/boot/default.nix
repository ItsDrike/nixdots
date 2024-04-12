{ config, lib, pkgs, ...}: let
  inherit (lib) mkOption mkEnableOption literalExpression;

  cfg = config.myOptions.system.boot;
in {
  imports = [
    ./secure-boot.nix
    ./plymouth.nix
  ];

  options.myOptions.system.boot = {
    kernel = mkOption {
      type = with lib.types; nullOr raw;
      default = pkgs.linuxPackages_latest;
      example = literalExpression "pkgs.linuxPackages_latest";
      description = "The kernel to use for the system.";
    };

    tmpOnTmpfs =
      mkEnableOption ''
        `/tmp` living on tmpfs. false means it will be cleared manually on each reboot

        This option defaults to `true` if the host provides patches to the kernel package in
        `boot.kernelPatches`
      '';

    silentBoot = mkEnableOption ''
      almost entirely silent boot process through `quiet` kernel parameter
    ''
    // { default = cfg.plymouth.enable; };
  };
}

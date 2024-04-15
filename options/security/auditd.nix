{ lib, config, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption literalExpression types;
in
{
  options.myOptions.security.auditd = {
    enable = mkEnableOption "the audit daemon.";
    autoPrune = {
      enable = mkEnableOption ''
        automatic pruning of audit logs.

        Enabling this is HEAVILY recommended, as audit logs
        can grow very large very quickly.
      '';

      size = mkOption {
        type = types.int;
        default = 524288000; # roughly 500MB
        description = ''
          The maximum size of the audit log in bytes.

          The default is 500MB.
        '';
      };

      schedule = mkOption {
        type = types.str;
        default = "daily";
        example = "weekly";
        description = "How often cleaning is triggered. Passed to systemd.time";
      };
    };

    extraFiles = mkOption {
      default = [];
      type = types.listOf types.path;
      example = literalExpression ''["/etc/nix/id_rsa"]'';
      description = ''
        Additional files in root to link to persistent storage.
      '';
    };

    extraDirectories = mkOption {
      default = [];
      type = types.listOf types.path;
      example = literalExpression ''["/etc/nix/id_rsa"]'';
      description = ''
        Additional directories in root to link to persistent storage.
      '';
    };

    persistentMountPoint = mkOption {
      default = "/persist";
      description = ''
        Path to a persistent directory (usually a mount point to a
        standalone partition / subvolume), which will hold the persistent
        system state files.
      '';
    };
  };
}


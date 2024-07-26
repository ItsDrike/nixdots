{lib, ...}:
with lib; let
  inherit (lib) mkEnableOption mkOption;
in {
  options.myOptions.home-manager.git = {
    userName = mkOption {
      type = types.str;
      default = "";
      description = "The default git user name.";
    };
    userEmail = mkOption {
      type = types.str;
      default = "";
      description = "The default git user email.";
    };

    signing = {
      enable = mkEnableOption ''
        git commit signing.
        Requires `myOptions.home-manager.git.signing.key` to be set.
      '';
      key = mkOption {
        type = types.str;
        default = "";
        description = "The defaul GPG key fingerprint for signing.";
      };
    };
  };
}

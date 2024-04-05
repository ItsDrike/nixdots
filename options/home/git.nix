{ lib, ... }: with lib; let
in
{
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
      enabled = mkOption {
        type = types.bool;
        default = true;
        description = "Should commits and tags be sgined by default?";
      };
      key = mkOption {
        type = types.str;
        default = "";
        description = "The defaul GPG key fingerprint for signing.";
      };
    };
  };
}

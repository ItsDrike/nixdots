{ lib, ... }: with lib; let
in
{
  options.myOptions.home-manager.git = {
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

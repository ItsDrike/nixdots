{ lib, ... }: with lib; let
in
{
  options.myOptions.system = {
    hostname = mkOption {
      description = "hostname for this system";
      type = types.str;
    };

    username = mkOption {
      description = "username for the primary admin account for this system";
      type = types.str;
    };
  };
}

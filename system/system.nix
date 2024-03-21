{ config, lib, ... }: with lib; let
  cfg = config.myOptions.system;
in
{
  networking.hostName = cfg.hostname;

  users = {
    # Prevent mutating users outside of our configurations.
    # TODO: Solve this, currentry it fails with no password
    # specified for root account nor any whell user accounts
    # and wants us to set pw manually with passwd, which needs
    # mutableUsers
    #mutableUsers = false;

    users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
    };
  };
}

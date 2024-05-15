{ config, lib, pkgs, ... }: with lib; let
  cfg = config.myOptions.system;
in
{
  networking.hostName = cfg.hostname;

  # Default shell for the user
  programs.zsh.enable = true;

  users = {
    users.${cfg.username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      shell = pkgs.zsh;
    };
  };
}

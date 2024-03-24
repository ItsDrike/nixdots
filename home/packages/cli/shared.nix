{ config, pkgs, lib, ... }:
let
  username = config.myOptions.system.username;
in
{
  home-manager.users.${username} = {
    home.packages = with pkgs; [
      fzf
      jq
      fd
      ripgrep
      unzip
      file
      rsync
      btop
      hyperfine
      delta
      gnupg
    ];
  };
}

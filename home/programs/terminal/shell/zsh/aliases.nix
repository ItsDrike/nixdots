{ config, ... }:
let
  username = config.myOptions.system.username;
in
{
  programs.zsh.shellAliases = {
    # I'm not the greatest typist
    sl = "ls";
    mdkir = "mkdir";
    soruce = "source";
    suod = "sudo";
    sduo = "sudo";

    # Directory changing
    ".." = "cd ..";
    "..." = "cd ../../";
    "...." = "cd ../../../";
    "....." = "cd ../../../../";
    ".2" = "cd ../../";
    ".3" = "cd ../../../";
    ".4" = "cd ../../../../";
    ".5" = "cd ../../../../../";

    # Files/Directories utilities
    mkdir = "mkdir -p";
    md = "mkdir";
    fhere = "find . -name";
    rr = "rm -r";
    rf = "rm -f";
    rrf = "rm -rf";
    vimdiff = "nvim -d";

    # Expand aliases from sudo
    sudo = "sudo ";
  };
}

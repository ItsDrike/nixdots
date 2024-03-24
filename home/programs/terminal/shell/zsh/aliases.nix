{ config, pkgs, lib, ... }:
let
  username = config.myOptions.system.username;

  inherit (lib.meta) getExe getExe';
in
{
  home-manager.users.${username} = {
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
      fcd = "cd $(find -type d | fzf)";
      mkdir = "mkdir -p";
      md = "mkdir";
      fhere = "find . -name";
      rr = "rm -r";
      rf = "rm -f";
      rrf = "rm -rf";
      vimdiff = "nvim -d";

      # Directory listing aliases
      ls = "ls --color=auto";
      l = "ls -lahX --classify";
      ll = "ls -lahX --classify --group-directories-first";
      ldir = "ls -lahX --classify | grep --color=never ^d";
      dotall = "ls -lahXd .[a-z]*";
      dotfiles = "dotall | grep -v ^d";
      dotdirs = "dotall | grep --color=never ^d";

      # File validation and manipulation
      yamlcheck = "${getExe pkgs.python3} -c 'import sys, yaml as y; y.safe_load(open(sys.argv[1]))'"; # Validate YAML
      jsoncheck = "${getExe pkgs.jq} "." >/dev/null <"; # Validate JSON
      urlencode = "${getExe pkgs.python3} -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]));'"; # Encode strings as URLs (space->%20, etc.)
      mergepdf = "${getExe pkgs.gnostscript} -q -dNOPAUSE -dBATCH -sDEVICE=pdfwrite -sOutputFile=_merged.pdf"; # Usage: `mergepdf input{1,2,3}.pdf``
      encrypt = "${getExe pkgs.gnupg} -c --no-symkey-cache --cipher-algo AES256"; # Encrypt file with AES256 symetric encryption

      # Get global IP address by querying opendns directly
      # (much better than using some random "what is my ip" service)
      # <https://unix.stackexchange.com/a/81699>
      canihazip = "${getExe pkgs.dig} @resolver4.opendns.com myip.opendns.com +short";
      canihazip4 = "${getExe pkgs.dig} @resolver4.opendns.com myip.opendns.com +short -4";
      canihazip6 = "${getExe pkgs.dig} @resolver1.ipv6-sandbox.opendns.com AAAA myip.opendns.com +short -6";

      # Expand aliases from sudo
      sudo = "sudo ";
    };
  };
}

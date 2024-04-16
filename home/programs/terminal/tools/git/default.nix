{ osConfig, pkgs, ... }:
let
  myGitConf = osConfig.myOptions.home-manager.git;
in
{
  imports = [
    ./gh.nix
    ./ignores.nix
    ./aliases.nix
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;

    userName = myGitConf.userName;
    userEmail = myGitConf.userEmail;

    signing = {
      signByDefault = myGitConf.signing.enable;
      key = myGitConf.signing.key;
    };

    delta.enable = true;

    extraConfig = {
      init.defaultBranch = "main";
      merge.conflictstyle = "diff3";
      delta.line-numbers = true;

      push = {
        default = "current";
        followTags = true;
      };

      url = {
        "https://github.com/".insteadOf = "github:";
        "ssh://git@github.com/".pushInsteadOf = "github:";
        "https://gitlab.com/".insteadOf = "gitlab:";
        "ssh://git@gitlab.com/".pushInsteadOf = "gitlab:";
        "https://aur.archlinux.org/".insteadOf = "aur:";
        "ssh://aur@aur.archlinux.org/".pushInsteadOf = "aur:";
        "https://git.sr.ht/".insteadOf = "srht:";
        "ssh://git@git.sr.ht/".pushInsteadOf = "srht:";
        "https://codeberg.org/".insteadOf = "codeberg:";
        "ssh://git@codeberg.org/".pushInsteadOf = "codeberg:";
      };
    };
  };

  home.packages = with pkgs; [
    gist # Manage github gists
    act # Run github actions locally
  ];
}

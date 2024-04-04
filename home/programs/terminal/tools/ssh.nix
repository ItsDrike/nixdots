{
  programs = {
    ssh = {
      enable = true;
      hashKnownHosts = true;
      compression = true;
      matchBlocks = {
        # Git hosts
        "aur" = {
          hostname = "aur.archlinux.org";
          identityFile = "~/.ssh/git/aur";
        };
        "gitlab" = {
          user = "git";
          hostname = "gitlab.com";
          identityFile = "~/.ssh/git/gitlab";
        };
        "github" = {
          user = "git";
          hostname = "gitlab.com";
          identityFile = "~/.ssh/git/github";
        };
        # TODO: Figure out how to add protected/encrypted blocks here
        # I don't like the idea of expising IPs/hostnames in the config
      };
    };
  };
}

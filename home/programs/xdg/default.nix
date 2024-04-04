{config, pkgs, ...}: {
  imports = [
    ./mime-apps.nix
    ./user-dirs.nix
  ];

  xdg = {
    enable = true;
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config";
    dataHome = "${config.home.homeDirectory}/.local/share";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  # These are not supported via xdg configuration, set them manually
  # Defined in /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    "XDG_RUNTIME_DIR" = "/run/user/$UID";
    "XDG_BIN_HOME" = "${config.home.homeDirectory}/.local/bin";
  };

  # xdg-ninja is a CLI tool that checks $HOME for unwanted
  # files/dirs and shows how to move them to XDG dirs
  home.packages = [ pkgs.xdg-ninja ];
}

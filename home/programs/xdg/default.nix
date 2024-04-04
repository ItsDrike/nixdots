{config, ...}: {
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

  # Set XDG_RUNTIME_DIR manually (not supported via xdg configuration)
  home.sessionVariables = {
    "XDG_RUNTIME_DIR" = "/run/user/$UID";
  };
}

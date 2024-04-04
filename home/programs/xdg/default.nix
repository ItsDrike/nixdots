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

  # Set XDG_RUNTIME_DIR manually (not supported via xdg configuration)
  home.sessionVariables = {
    "XDG_RUNTIME_DIR" = "/run/user/$UID";
  };

  # xdg-ninja is a CLI tool that checks $HOME for unwanted
  # files/dirs and shows how to move them to XDG dirs
  home.packages = [ pkgs.xdg-ninja ];
}

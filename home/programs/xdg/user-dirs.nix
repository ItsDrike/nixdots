# Manage $XDG_CONFIG_HOME/user-dirs.dirs
{config, ...}: {
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = null;
    documents = null;
    download = "${config.home.homeDirectory}/Downloads";

    publicShare = "${config.home.homeDirectory}/.local/share/public";
    templates = "${config.home.homeDirectory}/.local/share/templates";

    music = "${config.home.homeDirectory}/Media/Music";
    pictures = "${config.home.homeDirectory}/Media/Pictures";
    videos = "${config.home.homeDirectory}/Media/Videos";

    extraConfig = {
      XDG_SCREENSHOTS_DIR = "${config.xdg.userDirs.pictures}/Screenshots";
    };
  };
}

# Manage $XDG_CONFIG_HOME/mimeapps.list
{
  xdg.mimeApps = {
    enable = true;
    associations.added = let
      browser = "firefox.desktop";
      textEditor = browser; # nvim doesn't work properly with xdg-open, just use the browser
      fileManager = "pcmanfm-qt.desktop";
      archiveManager = "org.gnome.FileRoller.desktop";
      imageViewer = "org.nomacs.ImageLounge.desktop";
      videoPlayer = "mpv.desktop";
      audioPlayer = "mpv.desktop";
    in {
      "text/html" = [browser];
      "x-scheme-handler/http" = [browser];
      "x-scheme-handler/https" = [browser];
      "x-scheme-handler/about" = [browser];
      "x-scheme-handler/unknown" = [browser];
      "application/x-extension-htm" = [browser];
      "application/x-extension-html" = [browser];
      "application/x-extension-shtml" = [browser];
      "application/xhtml+xml" = [browser];
      "application/x-extension-xhtml" = [browser];
      "application/x-extension-xht" = [browser];

      "inode/directory" = [fileManager];
      "application/zip" = [archiveManager];
      "application/x-xz-compressed-tar" = [archiveManager];

      "image/*" = [imageViewer];
      "audio/*" = [audioPlayer];
      "video/*" = [videoPlayer];

      "text/plain" = [textEditor];
      "application/json" = [textEditor];

      "x-scheme-handler/spotify" = ["spotify.desktop"];
      "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
      "x-scheme-handler/msteams" = ["teams.desktop"]; # I need it for school, don't judge me
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    DEFAULT_BROWSER = "firefox";
  };
}

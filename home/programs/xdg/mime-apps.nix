# Manage $XDG_CONFIG_HOME/mimeapps.list
{
  osConfig,
  ...
}: let
  cfg = osConfig.myOptions.home-manager.programs;
in {
  xdg.mimeApps = let 
      browser = "firefox.desktop";
      textEditor = browser; # nvim doesn't work properly with xdg-open, just use the browser
      emailClient = browser;
      pdfViewer = browser; # TODO: consider zathura (org.pwmt.zathura.desktop.desktop)
      fileManager = "pcmanfm-qt.desktop"; # TODO: change
      archiveManager = "org.kde.ark.desktop";
      imageViewer = 
        if cfg.applications.qimgv.enable
        then "qimgv.desktop" 
        else if cfg.applications.nomacs.enable
        then "org.nomacs.ImageLounge.desktop"
        else browser;
      videoPlayer = "mpv.desktop";
      audioPlayer = "mpv.desktop";

      associations = {
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

        "application/pdf" = [pdfViewer];
        "x-scheme-handler/mailto" = [emailClient];

        "inode/directory" = [fileManager];
        "application/zip" = [archiveManager];
        "application/x-xz-compressed-tar" = [archiveManager];

        "image/*" = [imageViewer];
        "audio/*" = [audioPlayer];
        "video/*" = [videoPlayer];

        # The wildcard associations don't work everywhere, so we
        # still need specific ones
        "image/jpeg" = [imageViewer];
        "image/png" = [imageViewer];
        "image/svg+xml" = [imageViewer];
        "image/gif" = [imageViewer];
        "video/mp4" = [videoPlayer];

        "text/plain" = [textEditor];
        "application/json" = [textEditor];

        "x-scheme-handler/spotify" = ["spotify.desktop"];
        "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
        "x-scheme-handler/discord" = ["vesktop.desktop"];
        "x-scheme-handler/msteams" = ["teams.desktop"]; # I need it for school, don't judge me
      };
  in {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    DEFAULT_BROWSER = "firefox";
  };
}

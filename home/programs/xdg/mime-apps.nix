# Manage $XDG_CONFIG_HOME/mimeapps.list
{osConfig, ...}: let
  cfgPreferences = osConfig.myOptions.home-manager.preferences;
in {
  xdg.mimeApps = let
    browser = cfgPreferences.browser.desktop;
    textEditor = cfgPreferences.textEditor.desktop;
    emailClient = cfgPreferences.emailClient.desktop;
    documentViewer = cfgPreferences.documentViewer.desktop;
    fileManager = cfgPreferences.fileManager.desktop;
    archiveManager = cfgPreferences.archiveManager.desktop;
    imageViewer = cfgPreferences.imageViewer.desktop;
    mediaPlayer = cfgPreferences.mediaPlayer.desktop;

    associations = {
      # Browser
      "text/html" = [browser];
      "x-scheme-handler/http" = [browser];
      "x-scheme-handler/https" = [browser];
      "x-scheme-handler/about" = [browser];
      "x-scheme-handler/unknown" = [browser];
      "application/x-extension-htm" = [browser];
      "application/x-extension-html" = [browser];
      "application/x-extension-shtml" = [browser];
      "application/x-extension-xhtml" = [browser];
      "application/x-extension-xht" = [browser];
      "application/xhtml+xml" = [browser];
      "application/xhtml_xml" = [browser];

      # Image viewer
      "image/*" = [imageViewer]; # wildcard associations don't work everywhere
      "image/bmp" = [imageViewer];
      "image/gif" = [imageViewer];
      "image/jpeg" = [imageViewer];
      "image/jpg" = [imageViewer];
      "image/png" = [imageViewer];
      "image/webp" = [imageViewer];
      "image/tiff" = [imageViewer];
      "image/x-bmp" = [imageViewer];
      "image/x-pcx" = [imageViewer];
      "image/x-tga" = [imageViewer];
      "image/x-portable-pixmap" = [imageViewer];
      "image/x-portable-bitmap" = [imageViewer];
      "image/x-portable-greymap" = [imageViewer];
      "image/x-targa" = [imageViewer];
      "image/svg+xml" = [imageViewer];
      "image/svg_xml" = [imageViewer];

      # Media Player (video + audio)
      "video/*" = [mediaPlayer]; # wildcard associations don't work everywhere
      "audio/*" = [mediaPlayer]; # -||-
      "video/mpeg" = [mediaPlayer];
      "video/x-mpeg2" = [mediaPlayer];
      "video/x-mpeg3" = [mediaPlayer];
      "video/mp4v-es" = [mediaPlayer];
      "video/x-m4v" = [mediaPlayer];
      "video/mp4" = [mediaPlayer];
      "video/divx" = [mediaPlayer];
      "video/vnd.divx" = [mediaPlayer];
      "video/msvideo" = [mediaPlayer];
      "video/x-msvideo" = [mediaPlayer];
      "video/ogg" = [mediaPlayer];
      "video/quicktime" = [mediaPlayer];
      "video/vnd.rn-realvideo" = [mediaPlayer];
      "video/x-avi" = [mediaPlayer];
      "video/avi" = [mediaPlayer];
      "video/x-flic" = [mediaPlayer];
      "video/fli" = [mediaPlayer];
      "video/x-flc" = [mediaPlayer];
      "video/flv" = [mediaPlayer];
      "video/x-flv" = [mediaPlayer];
      "video/x-theora" = [mediaPlayer];
      "video/x-theora+ogg" = [mediaPlayer];
      "video/x-matroska" = [mediaPlayer];
      "video/mkv" = [mediaPlayer];
      "video/webm" = [mediaPlayer];
      "video/x-ogm" = [mediaPlayer];
      "video/x-ogm+ogg" = [mediaPlayer];
      "video/dv" = [mediaPlayer];
      "video/mp2t" = [mediaPlayer];
      "video/vnd.mpegurl" = [mediaPlayer];
      "video/3gp" = [mediaPlayer];
      "video/3gpp" = [mediaPlayer];
      "video/3gpp2" = [mediaPlayer];

      "application/x-cue" = [mediaPlayer];
      "application/vnd.ms-asf" = [mediaPlayer];
      "application/x-matroska" = [mediaPlayer];
      "application/x-ogm" = [mediaPlayer];
      "application/x-ogm-audio" = [mediaPlayer];
      "application/x-ogm-video" = [mediaPlayer];
      "application/x-shorten" = [mediaPlayer];
      "application/x-mpegurl" = [mediaPlayer];
      "application/vnd.apple.mpegurl" = [mediaPlayer];
      "application/ogg" = [mediaPlayer];
      "application/x-ogg" = [mediaPlayer];
      "application/mxf" = [mediaPlayer];
      "application/sdp" = [mediaPlayer];
      "application/smil" = [mediaPlayer];
      "application/x-smil" = [mediaPlayer];
      "application/streamingmedia" = [mediaPlayer];
      "application/x-streamingmedia" = [mediaPlayer];
      "application/vnd.rn-realmedia" = [mediaPlayer];
      "application/vnd.rn-realmedia-vbr" = [mediaPlayer];
      "application/x-extension-m4a" = [mediaPlayer];

      "audio/x-matroska" = [mediaPlayer];
      "audio/webm" = [mediaPlayer];
      "audio/vorbis" = [mediaPlayer];
      "audio/x-vorbis" = [mediaPlayer];
      "audio/x-vorbis+ogg" = [mediaPlayer];
      "audio/x-shorten" = [mediaPlayer];
      "audio/x-ape" = [mediaPlayer];
      "audio/x-wavpack" = [mediaPlayer];
      "audio/x-tta" = [mediaPlayer];
      "audio/AMR" = [mediaPlayer];
      "audio/ac3" = [mediaPlayer];
      "audio/eac3" = [mediaPlayer];
      "audio/amr-wb" = [mediaPlayer];
      "audio/flac" = [mediaPlayer];
      "audio/mp4" = [mediaPlayer];
      "audio/x-pn-au" = [mediaPlayer];
      "audio/3gpp" = [mediaPlayer];
      "audio/3gpp2" = [mediaPlayer];
      "audio/dv" = [mediaPlayer];
      "audio/opus" = [mediaPlayer];
      "audio/x-ms-asf" = [mediaPlayer];
      "audio/vnd.dts" = [mediaPlayer];
      "audio/vnd.dts.hd" = [mediaPlayer];
      "audio/x-adpcm" = [mediaPlayer];
      "audio/m3u" = [mediaPlayer];
      "audio/aac" = [mediaPlayer];
      "audio/x-aac" = [mediaPlayer];
      "audio/vnd.dolby.heaac.1" = [mediaPlayer];
      "audio/vnd.dolby.heaac.2" = [mediaPlayer];
      "audio/aiff" = [mediaPlayer];
      "audio/x-aiff" = [mediaPlayer];
      "audio/m4a" = [mediaPlayer];
      "audio/x-m4a" = [mediaPlayer];
      "audio/mp1" = [mediaPlayer];
      "audio/x-mp1" = [mediaPlayer];
      "audio/mp2" = [mediaPlayer];
      "audio/x-mp2" = [mediaPlayer];
      "audio/mp3" = [mediaPlayer];
      "audio/x-mp3" = [mediaPlayer];
      "audio/mpeg" = [mediaPlayer];
      "audio/mpeg2" = [mediaPlayer];
      "audio/mpeg3" = [mediaPlayer];
      "audio/mpegurl" = [mediaPlayer];
      "audio/x-mpegurl" = [mediaPlayer];
      "audio/mpg" = [mediaPlayer];
      "audio/x-mpg" = [mediaPlayer];
      "audio/rn-mpeg" = [mediaPlayer];
      "audio/musepack" = [mediaPlayer];
      "audio/x-musepack" = [mediaPlayer];
      "audio/ogg" = [mediaPlayer];
      "audio/scpls" = [mediaPlayer];
      "audio/x-scpls" = [mediaPlayer];
      "audio/vnd.rn-realaudio" = [mediaPlayer];
      "audio/wav" = [mediaPlayer];
      "audio/x-pn-wav" = [mediaPlayer];
      "audio/x-pn-windows-pcm" = [mediaPlayer];
      "audio/x-realaudio" = [mediaPlayer];
      "audio/x-pn-realaudio" = [mediaPlayer];
      "audio/x-ms-wma" = [mediaPlayer];
      "audio/x-pls" = [mediaPlayer];
      "audio/x-wav" = [mediaPlayer];

      # Document Viewer
      "application/pdf" = [documentViewer];
      "application/epub" = [documentViewer];
      "application/djvu" = [documentViewer];
      "application/mobi" = [documentViewer];

      # File & archive manager(s)
      "inode/directory" = [fileManager];
      "application/zip" = [archiveManager];
      "application/x-xz-compressed-tar" = [archiveManager];

      # Plain-text
      "text/plain" = [textEditor];
      "application/json" = [textEditor];

      # Application specific schemes
      "x-scheme-handler/spotify" = ["spotify.desktop"];
      "x-scheme-handler/tg" = ["telegramdesktop.desktop"];
      "x-scheme-handler/discord" = ["vesktop.desktop"];
      "x-scheme-handler/msteams" = ["teams.desktop"]; # I need it for school, don't judge me

      # Misc
      "x-scheme-handler/mailto" = [emailClient];
    };
  in {
    enable = true;
    associations.added = associations;
    defaultApplications = associations;
  };

  home.sessionVariables = {
    BROWSER = cfgPreferences.browser.command;
    DEFAULT_BROWSER = cfgPreferences.browser.command;
    TERMINAL = cfgPreferences.terminalEmulator.command;
  };
}

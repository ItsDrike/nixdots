{
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.spotify;
  spicePkgs = inputs.spicetify.legacyPackages.${pkgs.system};
in {
  imports = [inputs.spicetify.homeManagerModules.default];
  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledCustomApps = with spicePkgs.apps; [
        # Official apps
        lyricsPlus
        newReleases

        # Community apps
        ncsVisualizer
        historyInSidebar
      ];

      enabledExtensions = with spicePkgs.extensions; [
        # Official extensions
        bookmark
        fullAppDisplay
        loopyLoop
        popupLyrics
        shuffle
        trashbin

        # Community extensions
        groupSession
        skipOrPlayLikedSongs
        fullAlbumDate
        goToSong
        listPlaylistsWithSong
        wikify
        songStats
        showQueueDuration
        history
        betterGenres
        #hidePodcasts
        #adblock # I currently have premium
        playNext
        volumePercentage
        copyLyrics
        playingSource
      ];
    };
  };
}

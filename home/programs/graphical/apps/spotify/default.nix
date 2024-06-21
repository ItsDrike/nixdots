{
  lib,
  osConfig,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.spotify;
  spicePkgs = inputs.spicetify.packages.${pkgs.system}.default;
in {
  imports = [inputs.spicetify.homeManagerModule];
  config = mkIf cfg.enable {
    programs.spicetify = {
      enable = true;
      injectCss = true;
      replaceColors = true;

      overwriteAssets = true;
      sidebarConfig = true;
      enabledCustomApps = with spicePkgs.apps; [
        lyrics-plus
        new-releases
      ];

      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";

      enabledExtensions = with spicePkgs.extensions; [
        fullAppDisplay
        shuffle # shuffle+ (special characters are sanitized out of ext names)
        hidePodcasts
        playlistIcons
        lastfm
        historyShortcut
        bookmark
        fullAlbumDate
        groupSession
        popupLyrics
        # TODO: genre, see: https://github.com/the-argus/spicetify-nix/issues/50
      ];
    };
  };
}

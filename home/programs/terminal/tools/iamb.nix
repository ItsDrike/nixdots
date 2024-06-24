{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.applications.iamb;
in {
  config = mkIf cfg.enable {
    home.packages = with pkgs; [ iamb ];

    xdg.configFile."iamb/config.json".text = builtins.toJSON {
      settings = {
        log_level = "warn";
        reaction_display = true;
        reaction_shortcode_display = false;
        read_receipt_send = false;
        read_receipt_display = true;
        request_timeout = 15000;
        typing_notice_send = true;
        typing_notice_display = true;

        image_preview = {
          protocol.type = "kitty";
          size = {
            width = 80;
            height = 24;
          };
        };
      };

      default_profile = cfg.defaultProfile;
      profiles = lib.mapAttrs (name: profile: {
        user_id = profile.userId;
        url = profile.homeServer;
      }) cfg.profiles;

      dirs = {
        cache = "${config.xdg.cacheHome}/iamb/";
        logs = "${config.xdg.dataHome}/iamb/logs/";
        downloads = "${config.xdg.userDirs.download}/";
      };
    };
  };
}

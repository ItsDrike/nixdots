{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  cfg = config.myOptions.system.boot.plymouth;
in {
  config = mkIf cfg.enable {
    boot = {
      plymouth =
        {
          enable = true;
          theme = cfg.selectedTheme;
        }
        // lib.optionalAttrs cfg.withThemes {
          themePackages = [
            (pkgs.adi1090x-plymouth-themes.override {
              selected_themes = [cfg.selectedTheme];
            })
          ];
        };

      kernelParams = ["splash"];
    };

    # Make polymouth work with sleep
    powerManagement = {
      powerDownCommands = ''
        ${pkgs.plymouth} --show-splash
      '';
      resumeCommands = ''
        ${pkgs.plymouth} --quit
      '';
    };
  };
}

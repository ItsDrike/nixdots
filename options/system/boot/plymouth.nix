{ lib, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.myOptions.system.boot.plymouth = {
    enable = mkEnableOption ''Plymouth boot splash.'';

    withThemes = mkEnableOption ''
      Whether or not themes from https://github.com/adi1090x/plymouth-themes
      should be enabled and configured.
    '';

    selectedTheme = mkOption {
      type = types.str;
      default = "bgrt";
      description = ''
        Choose which theme to use.

        If you have `myOptions.system.boot.plymouth.withThemes` enabled, you can use more themes from the
        https://github.com/adi1090x/plymouth-themes project. You can find the the available theme names at
        https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/themes/adi1090x-plymouth-themes/shas.nix.
      '';
    };
  };
}

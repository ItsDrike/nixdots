{ lib, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption types;
in
{
  options.myOptions.home-manager.programs = {
    launchers = {
      wofi.enable = mkEnableOption "Wofi launcher";
      walker.enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable Walker launcher.";
      };
    };
  };
}

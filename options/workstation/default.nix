{ lib, config, ... }: with lib; let
  inherit (lib) mkEnableOption mkOption literalExpression types;

  cfg = config.myOptions.workstation;
in
{
  options.myOptions.workstation = {
    printing = {
      enable = mkEnableOption ''
        printing support using cups.

        Also adds some drivers for common printers.
      '';

      hplip.enable = mkEnableOption ''
        HP printing support using hplip software.
      '';
    };
  };
}

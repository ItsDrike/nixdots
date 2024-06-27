{
  lib,
  pkgs,
  config,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.coding.python;

  toTOML = name: (pkgs.formats.toml {}).generate "${name}";
in {
  config = mkIf cfg.enable {
    home = {
      packages = with pkgs; [ rye ];

      sessionVariables = {
        RYE_HOME = "${config.xdg.configHome}/rye";
      };

      # Add rye python shims to path.
      # Rye provides python executables that will automatically pick up on the python
      # from a virtual environment, if we're in a directory (project) with one. If not,
      # rye will fall back to system python. That is, if behavior.global-python=false,
      # otherwise, we can actually use a python version from rye as our global python.
      sessionPath = [
        "${config.xdg.configHome}/rye/shims"
      ];
    };

    # see: <https://rye.astral.sh/guide/config/#config-file>
    xdg.configFile."rye/config.toml".source = toTOML "config.toml" {
      default.license = "GPL-3.0-or-later";
      behavior.global-python=true;
    };
  };
}

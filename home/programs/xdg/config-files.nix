# Attribute set of files to link into the user's XDG directories
{ config, ... }: let
  XDG_CACHE_HOME = config.xdg.cacheHome;
  XDG_CONFIG_HOME = config.xdg.configHome;
  XDG_DATA_HOME = config.xdg.dataHome;
  XDG_STATE_HOME = config.xdg.stateHome;
  XDG_RUNTIME_DIR = config.home.sessionVariables.XDG_RUNTIME_DIR;
  XDG_BIN_HOME = config.home.sessionVariables.XDG_BIN_HOME;
in {

  # Variables set to force apps into the XDG base directories
  # These will get set at login
  # Defined in /etc/profiles/per-user/$USER/etc/profile.d/hm-session-vars.sh
  home.sessionVariables = {
    # General applications / tools
    LESSHISTFILE = "${XDG_CACHE_HOME}/less/history";
    WINEPREFIX = "${XDG_DATA_HOME}/wine";
    MPLAYER_HOME = "${XDG_CONFIG_HOME}/mplayer";
    WAKATIME_HOME = "${XDG_DATA_HOME}/wakatime";
    SQLITE_HISTORY = "${XDG_CACHE_HOME}/sqlite_history";
    PARALLEL_HOME = "${XDG_CONFIG_HOME}/parallel";

    # Programming languages / tools / package managers
    ANDROID_HOME = "${XDG_DATA_HOME}/android";
    DOCKER_CONFIG = "${XDG_CONFIG_HOME}/docker";
    GRADLE_USER_HOME = "${XDG_DATA_HOME}/gradle";
    GOPATH = "${XDG_DATA_HOME}/go";
    M2_HOME = "${XDG_DATA_HOME}/m2";
    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${XDG_CONFIG_HOME}/java";
    CARGO_HOME = "${XDG_DATA_HOME}/cargo";
    ## npm/node
    NODE_REPL_HISTORY = "${XDG_DATA_HOME}/node_repl_history";
    NPM_CONFIG_USERCONFIG = "${XDG_CONFIG_HOME}/npm/npmrc";
    NPM_CONFIG_PREFIX = "${XDG_DATA_HOME}/npm";
    NPM_CONFIG_CACHE = "${XDG_CACHE_HOME}/npm";
    NPM_CONFIG_TMP = "${XDG_RUNTIME_DIR}/npm";
    ## dotnet
    DOTNET_CLI_HOME = "${XDG_DATA_HOME}/dotnet";
    NUGET_PACKAGES = "${XDG_CACHE_HOME}/NuGetPackages";
    ## Python
    PYTHONSTARTUP = "${XDG_CONFIG_HOME}/python/pythonrc.py";
    PYTHONPYCACHEPREFIX = "${XDG_CACHE_HOME}/python";
    PYTHONUSERBASE = "${XDG_DATA_HOME}/python";
    MYPY_CACHE_DIR = "${XDG_CACHE_HOME}/mypy";
    IPYTHONDIR = "${XDG_CONFIG_HOME}/ipython";
    JUPYTER_CONFIG_DIR = "${XDG_CONFIG_HOME}/jupyter";
  };

  # Create the following files in XDG_CONFIG_HOME, for purposes of
  # forcing apps to use the XDG base directories 
  xdg.configFile = {
    "npm/npmrc".text = ''
      prefix=${XDG_DATA_HOME}/npm
      cache=${XDG_CACHE_HOME}/npm
      tmp=${XDG_RUNTIME_DIR}/npm
      init-module=${XDG_CONFIG_HOME}/npm/config/npm-init.js
    '';

    "python/pythonrc.py".text = ''
      import atexit
      import os
      import readline
      from functools import partial
      from pathlib import Path
      from types import ModuleType

      cache_xdg_dir = Path(
          os.environ.get("XDG_CACHE_HOME", str(Path("~/.cache").expanduser()))
      )
      cache_xdg_dir.mkdir(exist_ok=True, parents=True)

      history_file = cache_xdg_dir.joinpath("python_history")
      history_file.touch()

      readline.read_history_file(history_file)


      def write_history(readline: ModuleType, history_file: Path) -> None:
          """
          We need to get ``readline`` and ``history_file`` as arguments, as it
          seems they get garbage collected when the function is registered and
          the program ends, even though we refer to them here.
          """
          readline.write_history_file(history_file)


      atexit.register(partial(write_history, readline, history_file))
    '';
  };
}

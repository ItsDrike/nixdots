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
      def is_vanilla() -> bool:
          import sys
          return not hasattr(__builtins__, '__IPYTHON__') and 'bpython' not in sys.argv[0]


      def setup_history():
          import os
          import atexit
          import readline
          from pathlib import Path

          if state_home := os.environ.get('XDG_STATE_HOME'):
              state_home = Path(state_home)
          else:
              state_home = Path.home() / '.local' / 'state'

          history: Path = state_home / 'python_history'

          # https://github.com/python/cpython/issues/105694
          if not history.is_file():
            readline.write_history_file(str(history)) # breaks on macos + python3 without this. 

          readline.read_history_file(str(history))
          atexit.register(readline.write_history_file, str(history))


      if is_vanilla():
          setup_history()
    '';
  };

  # Set the following aliases to force applications to use a config file
  # in the proper XDG location
  home.shellAliases = {
    wget = "wget --hsts-file='\${XDG_DATA_HOME}/wget-hsts'";
  };
}

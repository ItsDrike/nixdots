{
  programs.git.ignores = [
    # Python:
    "__pycache__/"
    "*.py[cod]"
    "$py.class"
    "venv"
    ".venv"
    ".pytest_cache"
    ".mypy_cache"

    # C
    ".tags"
    "tags"
    "*~"
    "*.o"
    "*.so"
    "*.cmake"
    "CmakeCache.txt"
    "CMakeFiles/"
    "cmake-build-debug/"
    "compile_commands.json"
    ".ccls*"

    # JavaScript + TypeScript
    "node_modules/"

    # Editors
    ".vscode/"
    ".idea/"
    ".replit"
    ".spyproject/"
    ".spyderproject"
    ".neoconf.json"

    # Custom attributes for folders on Mac OS
    ".DS_Store"
  ];
}

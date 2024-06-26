{
  lib,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;

  cfg = osConfig.myOptions.home-manager.programs.coding.python;
in {
  config = mkIf cfg.enable {
    programs.ruff = {
      enable = true;

      settings = {
        line-length = 119;
        lint = {
          select = [
            "F"     # Pyflakes
            "E"     # Pycodestyle (errors)
            "W"     # Pycodestyle (warnigns)
            "N"     # pep8-naming
            "D"     # pydocstyle
            "UP"    # pyupgrade
            "YTT"   # flake8-2020
            "ANN"   # flake8-annotations
            "ASYNC" # flake8-async
            "S"     # flake8-bandit
            "BLE"   # flake8-blind-except
            "B"     # flake8-bugbear
            "A"     # flake8-builtins
            "COM"   # flake8-commas
            "C4"    # flake8-comprehensions
            "DTZ"   # flake8-datetimez
            "T10"   # flake8-debugger
            "EM"    # flake8-errmsg
            "EXE"   # flake8-executable
            "FA"    # flake8-future-annotations
            "ISC"   # flake8-implicit-str-concat
            "ICN"   # flake8-import-conventions
            "LOG"   # flake8-logging
            "G"     # flake8-logging-format
            "INP"   # flake8-no-pep420
            "PIE"   # flake8-pie
            "T20"   # flake8-print
            "PYI"   # flake8-pyi
            "PT"    # flake8-pytest-style
            "Q"     # flake8-quotes
            "RSE"   # flake8-raise
            "RET"   # flake8-return
            "SLOT"  # flake8-slots
            "SIM"   # flake8-simplify
            "TID"   # flake8-tidy-imports
            "TCH"   # flake8-type-checking
            "INT"   # flake8-gettext
            "PTH"   # flake8-use-pathlib
            "TD"    # flake8-todos
            "ERA"   # flake8-eradicate
            "PGH"   # pygrep-hooks
            "PL"    # pylint
            "TRY"   # tryceratops
            "FLY"   # flynt
            "PERF"  # perflint
            "RUF"   # ruff-specific rules
          ];
          ignore = [
            "D100" # Missing docstring in public module
            "D104" # Missing docstring in public package
            "D105" # Missing docstring in magic method
            "D107" # Missing docstring in __init__
            "D203" # Blank line required before class docstring
            "D213" # Multi-line summary should start at second line (incompatible with D212)
            "D301" # Use r""" if any backslashes in a docstring
            "D405" # Section name should be properly capitalized
            "D406" # Section name should end with a newline
            "D407" # Missing dashed underline after section
            "D408" # Section underline should be in the line following the section's name
            "D409" # Section underline should match the length of its name
            "D410" # Missing blank line after section
            "D411" # Missing blank line before section
            "D412" # No blank lines allowed between a section header and its content
            "D413" # Missing blank line after last section
            "D414" # Section has no content
            "D416" # Section name should end with a colon
            "D417" # Missing argument descrition in the docstring

            "ANN002" # Missing type annotation for *args
            "ANN003" # Missing type annotation for **kwargs
            "ANN101" # Missing type annotation for self in method
            "ANN102" # Missing type annotation for cls in classmethod
            "ANN204" # Missing return type annotation for special method
            "ANN401" # Dynamically typed expressions (typing.Any) disallowed

            "SIM102" # use a single if statement instead of nested if statements
            "SIM108" # Use ternary operator {contents} instead of if-else-block

            "TCH001" # Move application imports used only for annotations into a type-checking block
            "TCH002" # Move 3rd-party imports used only for annotations into a type-checking block
            "TCH003" # Move standard library imports used only for annotations into a type-checking block

            "TD002" # Missing author in TODO
            "TD003" # Missing issue link on the line following this TODO

            "PT011"   # pytest.raises without match parameter is too broad # TODO: Unignore this
            "TRY003"  # No f-strings in raise statements
            "EM101"   # No string literals in exception init
            "EM102"   # No f-strings in exception init
            "UP024"   # Using errors that alias OSError
            "PLR2004" # Using unnamed numerical constants
            "PGH003"  # Using specific rule codes in type ignores
            "E731"    # Don't asign a lambda expression, use a def

            # Redundant rules with ruff-format:
            "E111"   # Indentation of a non-multiple of 4 spaces
            "E114"   # Comment with indentation  of a non-multiple of 4 spaces
            "E117"   # Cheks for over-indented code
            "D206"   # Checks for docstrings indented with tabs
            "D300"   # Checks for docstring that use ''' instead of """
            "Q000"   # Checks of inline strings that use wrong quotes (' instead of ")
            "Q001"   # Multiline string that use wrong quotes (''' instead of """)
            "Q002"   # Checks for docstrings that use wrong quotes (''' instead of """)
            "Q003"   # Checks for avoidable escaped quotes ("\"" -> '"')
            "COM812" # Missing trailing comma (in multi-line lists/tuples/...)
            "COM819" # Prohibited trailing comma (in single-line lists/tuples/...)
            "ISC001" # Single line implicit string concatenation ("hi" "hey" -> "hihey")
            "ISC002" # Multi line implicit string concatenation
          ];
          extend-per-file-ignores = {
            "tests/*" = [
              "ANN"  # flake8-annotations
              "S101" # Use of assert
            ];
            "docs/conf.py" = [
              "INP" # allow implicit namespace (pep 420)
            ];
          };
          isort = {
            order-by-type = false;
            case-sensitive = true;
            combine-as-imports = true;

            # Redundant rules with ruff-format
            force-single-line = false;       # forces all imports to appear on their own line
            force-wrap-aliases = false;      # Split imports with multiple members and at least one alias
            lines-after-imports = -1;        # The number of blank lines to place after imports
            lines-between-types = 0;         # Number of lines to place between "direct" and import from imports
            split-on-trailing-comma = false; # if last member of multiline import has a comma, don't fold it to single line
          };
          pylint = {
            max-args = 20;
            max-branches = 20;
            max-returns = 20;
            max-statements = 250;
          };
          flake8-tidy-imports = {
            ban-relative-imports = "all";
          };
        };
        format = {
          line-ending = "lf";
        };
      };
    };
  };
}

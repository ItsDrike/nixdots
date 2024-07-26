{pkgs, ...}: {
  programs.helix = {
    enable = true;

    settings = {
      theme = "tokyonight";
      editor = {
        line-number = "relative";
        bufferline = "multiple";
        cursor-shape.insert = "bar";
        lsp.display-messages = true;
      };
      keys = {
        normal = {
          esc = ["collapse_selection" "keep_primary_selection"];
        };
      };
    };

    languages = {
      language = [
        {
          name = "python";
          scope = "source.python";
          injection-regex = "python";
          file-types = ["py" "pyi" "py3" "pyw" ".pythonstartup" ".pythonrc"];
          shebangs = ["python"];
          roots = ["." "pyproject.toml" "pyrightconfig.json"];
          comment-token = "#";
          language-servers = ["basedpyright" "ruff"];
          indent = {
            tab-width = 4;
            unit = "    ";
          };
          auto-format = true;
        }
      ];
      language-server = {
        ruff = {
          command = "ruff-lsp";
        };
        basedpyright = {
          command = "basedpyright-langserver";
          args = ["--stdio"];
        };
      };
    };
  };
}

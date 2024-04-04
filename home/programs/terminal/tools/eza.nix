# Eza is an alternative to ls, written in Rust
{
  programs.eza = {
    enable = true;
    icons = true;
    git = true;
    enableZshIntegration = false;
    extraOptions = [
      "--group-directories-first"
      "--header"
    ];
  };
}

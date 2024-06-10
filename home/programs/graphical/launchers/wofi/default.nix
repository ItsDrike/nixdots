_: {
  programs.wofi = {
    enable = true;
    settings = {
      width = "40%";
      height = "30%";
      show = "drun";
      prompt = "Search";
      allow_images = true;
      allow_markup = true;
      insensitive = true;
    };
    style = ''
      ${builtins.readFile ./style.css}
    '';
  };
}

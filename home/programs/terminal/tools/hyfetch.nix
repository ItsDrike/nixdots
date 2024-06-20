{
  programs.hyfetch = {
    enable = true;
    settings = {
      preset = "rainbow";
      mode = "rgb";
      light_dark = "dark";
      lightness = 0.65;
      color_align = {
        mode = "horizontal";
        custom_colors = [];
        force_back = null;
      };
      backend = "neofetch";
      args = null;
      distro = null;
      pride_month_shown = [];
      pride_month_disable = true;
    };
  };
}

{
  dconf.settings = {
    # This is like a system-wide dark mode swithc that some apps respect
    # Equivalent of the following dconf command:
    # `conf write /org/gnome/desktop/interface/color-scheme "'prefer-dark'"`
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}

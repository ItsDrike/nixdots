{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    walker
  ];

  xdg.configFile = {
    "walker/config.json".source = ./config.json;
    "walker/style.css".source = ./style.css;
  };
}

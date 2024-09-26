{pkgs, ...}: {
  home.packages = with pkgs; [ninja];
}

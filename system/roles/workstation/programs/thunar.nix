{pkgs, ...}: {
  # Unconditionally enable thunar file manager here as a relatively
  # lightweight fallback option for my default file manager.
  programs.thunar = {
    enable = true;

    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-media-tags-plugin
    ];
  };

  environment = {
    systemPackages = with pkgs; [
      # packages necessery for thunar thumbnails
      xfce.tumbler
      libgsf # odf files
      ffmpegthumbnailer
      ark # GUI archiver for thunar archive plugin
    ];
  };

  # thumbnail support on thunar
  services.tumbler.enable = true;
}

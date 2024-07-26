{
  pkgs,
  lib,
  ...
}: {
  services.logrotate.settings.header = {
    # general
    global = true;
    dateext = true;
    dateformat = "-%Y-%m-%d";
    nomail = true;
    missingok = true;
    copytruncate = true;

    # rotation frequency
    priority = 1;
    frequency = "weekly";
    rotate = 7; # special value, means 7 days
    minage = 7; # avoid rotating files that are less than 7 days old

    # compression
    compress = true; # compress logs to save space
    compresscmd = "${lib.getExe' pkgs.zstd "zstd"}";
    compressoptions = " -Xcompression-level 10";
    compressext = "zst";
    uncompresscmd = "${lib.getExe' pkgs.zstd "unzstd"}";
  };
}

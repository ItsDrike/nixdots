{
  programs.btop = {
    enable = true;
    settings = {
      update_ms = 2000; # recommended >=2s for good graph sample rate
      proc_sorting = "memory";
      proc_tree = true; # show processes in  tree view (showing parent/child relationships)
      base_10_sizes = false; # us KB instead of KiB
      clock_format = "%X";
      log_level = "WARNING";
    };
  };
}

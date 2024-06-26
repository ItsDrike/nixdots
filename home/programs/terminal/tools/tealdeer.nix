# Implementation of tldr in rust
{
  programs = {
    tealdeer = {
      enable = true;
      settings = {
        display = {
          compact = false;
          use_pager = true;
        };
        updates = {
          auto_update = true;
          auto_update_interval_hours = 720; # 30 days
        };
      };
    };
  };
}

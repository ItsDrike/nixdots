{
  # Screen locker which works across all virtual terminals
  # Use `systemctl start physlock` to securely lock the screen
  services.physlock = {
    enable = true;
    lockMessage = "System is locked...";
  };
}

{pkgs, ...}:
{
  # Basic list of must-have packages for all systems
  environment.systemPackages = with pkgs; [
    vim
    gnupg
    delta
  ];
}

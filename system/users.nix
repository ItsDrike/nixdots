{pkgs, ...}:
{
  users.users.itsdrike = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "itsdrike";
  };
}

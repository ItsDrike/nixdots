{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    killall
    openssl
  ];
}

{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    killall
    openssl
    curl
    wget
    pciutils
    lshw
    man-pages
    rsync
    bind.dnsutils
  ];
}

{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    curl
    wget
    pciutils
    lshw
    man-pages
    rsync
    bind.dnsutils
  ];
}

{lib, ...}:
{
    imports = [
        ./network.nix
        ./users.nix
        ./nix.nix
        ./packages.nix
    ];

    # Internationalisation properties
    time.timeZone = "CET";
    i18n.defaultLocale = "en_US.UTF-8";
}

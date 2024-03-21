{pkgs, ...}:
{
  system.autoUpgrade.enable = false;

  nix = {
    settings = {
      # nix often takes up a lot of space, with /nix/store growing beyond reasonable sizes
      # this turns on automatic optimisation of the nix store that will run during every build
      # (alternatively, you can do this manually with `nix-store --optimise`)
      auto-optimise-store = true;
      # enable flakes support
      experimental-features = [ "nix-command" "flakes" ];

      # Keep all dependencies used to build
      keep-outputs = true;
      keep-derivations = true;
    };

    # Enable automatic garbage collection, deleting entries older than 14 days
    # you can also run this manually with `nix-store --gc --delete-older-than 14d`.
    # If a result still exists in the file system, all the dependencies used to build
    # it will be kept.
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    # Also run garbage colleciton whenever there is not enough space left,
    # freeing up to 1 GiB whenever there is less than 512MiB left.
    extraOptions = ''
      min-free = ${toString (512 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };

  nixpkgs.config.allowUnfree = true;

  # Git is needed for flakes
  environment.systemPackages = [pkgs.git];
}

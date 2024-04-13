{ pkgs, ... }:
{

  imports = [
    ./cachix.nix
    ./gc.nix
  ];

  system.autoUpgrade.enable = false;

  nix = {
    settings = {
      # enable flakes support
      experimental-features = [ "nix-command" "flakes" ];

      # Keep the built outputs of derivations in Nix store, even if the package is no longer needed
      # - prevents the need to rebuild/redownload if it becomes a dependency again
      # - helps with debugging or reverting to previous state
      keep-outputs = true;
      # Keep the derivations themselves too. A derivation describes how to build a package.
      # - allows inspecting the build process of a package for debugging or educational purposes
      # - allows rebuilding a package from its exact specification without having to fetch again
      # - ensures we can reproduce a build even if the original online source goes down/changes
      keep-derivations = true;

      # Give these users/groups additional rights when connecting to the Nix daemon
      # like specifying extra binary caches
      trusted-users = [ "root" "@wheel" ];

      # Tell nix to use xdg base directories
      # If you're just setting this, you will need to move the directories
      # manually, nix won't do it for you:
      # - mv "$HOME/.nix-defexpr" "$XDG_STATE_HOME/nix/defexpr"
      # - mv "$HOME/.nix-profile" "$XDG_STATE_HOME/nix/profile" 
      use-xdg-base-directories = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Git is needed for flakes
  environment.systemPackages = [ pkgs.git ];
}

_: {
  nix.settings = {
    # Set up various binary cache providers, compiling everything is too slow and annoying
    # these will be used on all machines, but there's really no reason not to include all
    # providers, even if we won't pull some of the packages these cache
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org" # nix-community flake
      "https://nixpkgs-unfree.cachix.org" # unfree-package cache
      "https://numtide.cachix.org" # another unfree package cache
      "https://nixpkgs-wayland.cachix.org" # automated builds of *some* wayland packages
      "https://hyprland.cachix.org" # hyprland
      "https://hyprland-community.cachix.org" # hyprland-community
      "https://ags.cachix.org" # ags
      "https://walker.cachix.org" # walker
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "nixpkgs-wayland.cachix.org-1:3lwxaILxMRkVhehr5StQprHdEo4IrE8sRho9R9HOLYA="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "hyprland-community.cachix.org-1:5dTHY+TjAJjnQs23X+vwMQG4va7j+zmvkTKoYuSXnmE="
      "ags.cachix.org-1:naAvMrz0CuYqeyGNyLgE010iUiuf/qx6kYrUv3NwAJ8="
      "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
    ];
  };
}

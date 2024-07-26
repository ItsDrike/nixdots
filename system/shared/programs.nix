{lib, ...}: let
  inherit (lib) mkForce;
in {
  programs = {
    # Explicitly disable nano, it sucks and I don't want it
    nano.enable = mkForce false;

    # Install an actually usable system-wide editor
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
      viAlias = true;
    };
  };
}

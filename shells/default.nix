{inputs, ...}: let 
  inherit (inputs) nixpkgs;

  system = "x86_64-linux";
  pkgs = nixpkgs.legacyPackages.${system};
in {
  ${system} = {
    default = pkgs.mkShell {
      name = "nixdots";
      meta.description = "The default development shell for my NixOS configuration";
      packages = with pkgs; [
        git # flakes require git
        nil # nix ls
        statix # lints and suggestions
        deadnix # clean up unused nix code
        alejandra # nix formatter
      ];
      shellHook = "exec $SHELL";
    };
  };
}

# NixDots

My NixOS and home-manager flake

## Structure

- [`docs`](./docs): Directory with various documents explaining the installation process, or other relevant topics.
- [`flake.nix`](./flake.nix): Starting point of the configuration, declaring entrypoints.
- [`system`](./system/): Basic core configurations for the system itself.
- [`home`](./home): Home-Manager configuration.
- [`options`](./options/): Declaration of the configurable options, that should be set by the individual machines.
- [`hosts`](./hosts): Configuration of the individual hosts/computers

## Inspiration

This configuration was massively inspired by the following amazing projects:

- <https://git.notashelf.dev/NotAShelf/nyx> (major inspiration)
- <https://github.com/spikespaz/dotfiles>
- <https://git.jacekpoz.pl/jacekpoz/niksos>
- <https://github.com/roastedcheese/nicks>
- <https://github.com/fufexan/dotfiles>
- <https://git.outfoxxed.me/outfoxxed/nixnew>
- <https://github.com/ErrorNoInternet/configuration.nix>
- <https://github.com/sioodmy/dotfiles>
- <https://github.com/n3oney/nixus>
- <https://codeberg.org/adamcstephens/dotfiles>
- <https://github.com/PerchunPak/nixos-dotfiles>

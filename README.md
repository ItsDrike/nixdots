# NixDots

My NixOS and home-manager flake

## Structure

- [`flake.nix`](./flake.nix): Starting point of the configuration, declaring entrypoints.
- [`guides`](./guides/): Some simple documentation to help me (and maybe others) understand NixOS.
- [`system`](./system/): Basic core configurations for the system itself.
- [`options`](./options/): Declaration of the configurable options, that should be set by the individual machines.
- [`hosts`](./hosts): Configuration of the individual hosts/computers

## Inspiration

This configuration was massively inspired by the following amazing projects:

- <https://git.jacekpoz.pl/jacekpoz/niksos>
- <https://git.notashelf.dev/NotAShelf/nyx/>

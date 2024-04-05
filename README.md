# NixDots

My NixOS and home-manager flake

## Structure

- [`flake.nix`](./flake.nix): Starting point of the configuration, declaring entrypoints.
- [`system`](./system/): Basic core configurations for the system itself.
- [`home`](./home): Home-Manager configuration.
- [`options`](./options/): Declaration of the configurable options, that should be set by the individual machines.
- [`hosts`](./hosts): Configuration of the individual hosts/computers

## Inspiration

This configuration was massively inspired by the following amazing projects:

- <https://git.notashelf.dev/NotAShelf/nyx/>
- <https://git.jacekpoz.pl/jacekpoz/niksos>

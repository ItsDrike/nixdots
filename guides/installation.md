# Installation

This is a full NixOS installation guide, from live cd to a working OS.
Once done, you will be left with a complete system, that uses my configuration.

This installation will push to use flakes out of the box, configuration.nix will
only be needed to add support for flakes and rebuild.

## Live ISO

This assumes you've chosen one of the ISO images with a graphical installer, and
followed though with the installation, getting you to a basic NixOS installation.

During this installation, make sure you allow non-free programs, and in the desktop environment selection, pick the option without any DE, we'll get to install that ourselves.

## Set up configuration.nix

Out of the box, NixOS only comes with `nano` editor, so we'll have to use that to edit the `configuration.nix` for the first time.

```sh
sudo nano configuration.nix
```

In there, change the `environment.systemPackages = with pkgs; [];` like, and include `git` and `vim`.

After that, let's enable flakes, by adding the following anywhere in your `configuration.nix`:

```nix
nix.package = pkgs.nixUnstable;
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Now you can save the changes and rebuild the system:

```sh
sudo nixos-rebuild switch
```

## Set up flakes

An interesting things about nix flakes, is that they need to live in a git
repository, you won't be able to rebuild otherwise, so let's set up some git
settings, so that we can make commits:

```sh
git config --global user.email "itsdrike@protonmail.com"
git config --global user.name "ItsDrike"
```

We could create and manage this repository directly in `/etc/nixos`, however
that's not practical, since we probably want to use our git config and
generally just work in a non-root environment when editing the flake. I like
using the `~/dots` directory.

```sh
cp -r /etc/nixos ~/dots
cd ~/dots
```

Now we have 2 options, the first one I'll show will set up my configuration
from this repository. Once done, you will have your system set up in the same
way that I do. In the second option, I will go over a basic setup to create
your own flake.

## Set up with my configuration

Finally, we're ready to migrate to flakes. At this point, you can simply pull this repository
to the `/etc/nixos` directory, to get my setup, like so:

```sh
git init
git remote add origin https://github.com/ItsDrike/nixdots
git branch -M main
git pull origin main
nixos-rebuild switch --flake .
```

## Create your own custom flake

Initialize an empty git repository:

```sh
git init
```

Create a very basic `./flake.nix`:

```sh
{
    description = "ItsDrike's NixOS configuration";

    inputs = {
      # the version here should match your system.stateVersion in configuration.nix
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    };

    outputs = { self, nixpkgs, ...} @ inputs: {
        nixosConfigurations = {
            nixos = nixpkgs.lib.nixosSystem {
                system = "x86_64-linux";
                modules = [ ./configuration.nix ];
            };
        };
    };
}
```

This flake will still rely on your `configuration.nix`, we will eventually get
to a config which does not need this file, but to make starting out with flakes
simple, we'll do it in this way for now.

Let's add things to git!

```sh
git add flake.nix
git add configuration.nix
git add hardware-configuration.nix
```

Now you can rebuild the system to use our flake:

```sh
sudo nixos-rebuild switch --flake .
```

Yay, you're now using NixOS in flakes mode!

> [!NOTE]
> If you run the `sudo nixos-rebuild switch` command, without the `--flake .`
> it would look for the `flake.nix` file in `/etc/nixos`.

> [!TIP]
> Notice the `nixosConfigurations` (plural) key in our flake, suggesting that
> it can hold multiple configurations. Indeed, it can! You can use a single
> flake to manage multiple systems.
>
> The name for the configuration just needs to match the hostname of your
> machine, which by default will be `nixos`.
>
> Alternatively, you can also pick which configuration to use manually in the
> rebuild command, like so: `nixos-rebuild --flake .#my-configuration`, which
> would pick a config named `my-configuration`.

You can notice that this also created a `flake.lock` file, containing the exact
versions of all of the packages you're using. Let's add this file to git too:
`git add flake.lock`.

And now we're ready to make our first commit:

```sh
git commit -m "Initial commit"
```

## Updating

Over time, to update the software that's installed on your machine, you can use
`nix flake update`, to update your `flake.lock` file, and then `nixos-rebuild
switch`, to get switch your system to the new dependencies.

> [!TIP]
> This replaces the legacy (non-flake) regime's command: `nixos-rebuild switch --upgrade`

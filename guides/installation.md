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

First thing you'll need to do is to make your useer account own the
`/etc/nixos` directory. You'll want to do this to allow you to easily manage
your config with git (which is a requirement when using flakes). You can use
system wide git, however it is much more convenient to just leave it to the
user, as you'll have your git configuration there.

```sh
cd /etc/nixos
sudo chmod -R itsdrike:users .
```

Out of the box, NixOS only comes with `nano` editor, so we'll have to use that to edit the `configuration.nix` for the first time.

```sh
nano configuration.nix
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

Now, since a git repository is required for flakes, let's set up git:

```sh
git config --global user.email "itsdrike@protonmail.com"
git config --global user.name "ItsDrike"
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
```

## Create your own custom flake

Initialize an empty git repository:

```sh
git init
```

Create a very basic `/etc/nixos/flake.nix`:

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

Now you can run `sudo nixos-rebuild switch`. Yay, you're now using NixOS in flakes mode!

> [!NOTE]
> If you run the `sudo nixos-rebuild switch` command before adding all of these
> files to git, you will get an error, so it really is a requirement to have
> your configuration in a git repository when you're using flakes.

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

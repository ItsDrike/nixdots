# Integrating my flake

This file will walk you through setting up my flake. You can follow this guide directly from
[INSTALLATION](./01_INSTALLATION.md), or after any of the other optional steps. This will however assume the minimal set
up that you would have after just finishing the installation, so if you're following from a more advanced setup, some
things here may be redundant.

This assumes that you're setting up a new machine, and adding it to my flake (as opposed to attempting to use an
existing machine that's already declared - for example after a reinstall, although after reading through this guide, it
should be fairly easy to understand how to set up an existing machine too).

## Clonning

Now, let's move your config over to my flake, creating a new host machine there. Unless you're me, you will want to fork
my nix flake repository so that you can actually push to it before continuing.

First, you will need to git clone the flake. However, in the base system, there is no git, so let's first add this
to our `configuration.nix`:

```nix
programs.git.enable = true;
```

Let's also enable flake support, so we can use `nix flake` command:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

and run `nixos-rebuild switch`

Once done, log in as your unprivileged user, and clone my flake: `git clone https://github.com/ItsDrike/nixdots ~/dots`.

## Setting up git for new commits

In order to make any extra commits, you will need to set up a git user now, and log in to github. For a quick and
dirty way to achieve this, I'd recommend just setting a local git config for the `~/dots` repository. This is enough
for now, as my flake will introduce proper git setup once cloned anyway:

```shell
cd ~/dots
git config --local user.name ItsDrike
git config --local user.email itsdrike@protonmail.com
```

If you also need commit signing, you can set it up by adding `gnupg` package, importing your keys and setting a signing
key here too, however, I'd recommend against that. Instead, you can just rebase and sign the commits afterwards, once
you have my flake set up, as it already contains support for this. Similarly, setting up authorization to allow you to
push to github with your account is also something you can do after my flake is set up.

For now, let's just work on a temporary branch:

```shell
git checkout -b temp
```

## Moving config over

At this point, we're ready to move our configuration over to my flake, by declaring a new host machine. To do this, first,
let's create a directory in `~/dots/hosts`, with the same name as you're machines hostname (you can call it something else
too if you like, but this is the naming convention I follow) (for some reason, the naming scheme for my machines follow
the names of famous sword from Lord of the Rings).

```shell
mkdir ~/dots/hosts/anduril
```

Now declare this host in `~/dots/hosts/default.nix`:

```nix
  anduril = lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      ./anduril
      inputs.home-manager.nixosModules.home-manager
    ] ++ shared;
  };
```

And copy the current files in `/etc/nixos/` to `~/dots/hosts/anduril`, renaming `configuration.nix` to `default.nix`

```shell
cp /etc/nixos/* ~/dots/hosts/anduril
mv ~/dots/hosts/anduril/{configuration.nix,default.nix}
```

## Adjusting some things

Once moved, assuming you get rid of most of the settings in `default.nix`, as my flake will
handle setting almost everything up for you. Instead, you can use my custom options to declare almost everything.
The resulting file should then look something like this:

```nix
{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;

  # My flake disables password-based SSH authentication.
  # either set up a key based auth, or uncomment this
  #services.openssh.settings.PasswordAuthentication = lib.mmkForce true;

  nix.settings = {
    max-jobs = 6;
    cores = 6;
  };

  # NixOS release from which this machine was first installed.
  # (for stateful data, like file locations and db versions)
  # Leave this alone!
  system.stateVersion = lib.mkForce "23.11";

  myOptions = {
    system = {
      hostname = "anduril";
      username = "itsdrike";

      #impermanence = {
      #  root = {
      #    enable = true;
      #    # Some people use /nix/persist/system for this, leaving persistent files in /nix subvolume
      #    # I much prefer using a standalone subvolume for this though.
      #    persistentMountPoint = "/persist";
      #  };
      #
      #  # Configure automatic root subvolume wiping on boot from initrd
      #  autoWipeBtrfs = {
      #    enable = true;
      #    devices."/dev/disk/by-label/NIXROOT".subvolumes = [ "root" ];
      #  };
      #};

      boot = {
        # Enable secure boot (requires running some commands afterwards, see the
        # option's docs before enabling)
        #secure-boot.enable = true;

        # I have enough RAM to afford using tmpfs for /tmp
        tmpOnTmpfs = true;
      };
    };

    device = {
      roles = {
        type = "laptop";
        virtual-machine = false;
      };
      cpu.type = "intel";
      hasTPM = true;
    };

    home-manager = {
      enabled = true;
      stateVersion = "23.11";
      git = {
        userName = "ItsDrike";
        userEmail = "itsdrike@protonmail.com";
        signing = {
          enabled = true;
          key = "FA2745890B7048C0";
        };
      };
    };
  };
}
```

## Commit and switch

Once you've declared everything, make a commit and run `nix flake check` to make sure you everything checks out,
and you didn't make any typos or other issues.

```shell
git add hosts
git commit -m "Add anduril host"
nix flake check .
```

> [!WARNING]
> If you're logged in through SSH, you will need to set up a key based authentication
> before switching, since password auth for SSH is disabled in my flake.

Finally, you should now be ready to switch:

```shell
sudo nixos-rebuild switch --flake .
```

If everything went well, you should now be left with a system configured to my specification.

## Last steps

Now that you've managed set up my flake, there are a few last steps to take.

First, you will probably now still be in a bash shell, I however use zsh, so you will want to re-login.

### Neovim

Once in zsh, another important step to set up neovim. Since I use a custom configuration, which relies on a lot of
plugins and other utilities, you will want to run neovim in headless mode for the first time, and leave it to install
all of these automatically:

```shell
nvim --headless +q
```

Once this completes, run neovim. Note that you will still see Mason installing a bunch of tools now, which will cause a
lot of notifications. Don't be alarmed by that, it is normal. Once the notifications stop, the installation process will
be truly complete. You can then close this instance neovim.

### XDG base dirs

My flake exports various environment variables and does a bunch of other things to force applications into following XDG
base directory specification and not cluttering `$HOME`.

However, since we used a bunch of applications already, before moving to my flake. There will be a bunch of files or
directories that already got made. We will need to move these to their appropriate XDG locations, or even delete them
entirely, if we're not using these applications anymore, or if these applications are capable of automatically
recreating these directories trivially:

```shell
rm "$HOME/.nix-defexpr"
rm "$HOME/.bash_history"
```

### GPG keys and commit signing

Another important thing is to finish up setting your git commit signing. As you've probably noticed from the myOptions
config, I have already defined my signing key there, however you will need to import this gpg key manually.

Export your public and private keys with GPG and make them available on this machine. To do so, you can run these
commands from another machine:

```shell
gpg --output ./my-key.pub.gpg --armor --export [key-id]
gpg --output ./my-key.priv.gpg --armor --export-secret-keys [key-id]
# Now get these files to the new machine
# you can use sftp, or just a flash drive or whatever other method you prefer
```

Once the keys are available, run these commands from the new machine:

```shell
gpg --import ./my-key.pub.gpg
gpg --import ./my-key.priv.gpg
```

You might also want to change the trust level for this key, which you can do with:

```shell
gpg --edit-key [key-id]
# In the interactive session, run `trust`, select your trust level and finally run `save`
```

My flake already configured your git to enable commit signing using the key you specified earlier (even though it wasn't
yet available at that point). Any new commits that you make from now on will be signed

### Git credentials

> [!WARNING]
> I don't yet have a proper set up for git credentials handled, for now, you can
> just use the HTTPS based authentication with store credential helper. Like what's
> described below. This category will however be completely rewritten and moved to
> SSH keys once I have support for them ready in the flake.

```shell
git config --local credential.helper "store --file ~/.config/git/git-credentials"
```

Now, once you run `git push`, you will be asked for a password, which will get stored
to `~/.config/git/git-credentials` (in plain-text, though the file is protected by file-system permissions, and only the
owner can read it).

### Push to git

First, let's remove our temporary hack with git local configuration we used to allow us to make commits:

```shell
git config --local --unset user.name
git config --local --unset user.email
```

Now that you have git set up, let's ammend our previous commits, which will recreate it, and this time, git will use our
global configuration with the gpg keys configured to sign the commits.

The following command will rebase all commits until we reach the `main` branch, from which we branched off, which means
it will sign all commits in our `temp` branch:

```shell
git rebase --exec 'git commit --amend --no-edit -n -S' -i main
```

Now that our commits are signed, we're ready to merge and push:

```shell
git checkout main
git rebase temp
git push
```

Done! We've just managed to add a new host to my flake and push the config back to git. You can now use this machine to
make any additional changes, whether that's host-specific ones or global ones.

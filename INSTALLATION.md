# Installation

This will walk you through the installation process from the minimal NixOS ISO to a system configured to use my flake.

This guide will walk you through setting up LUKS encryption with BTRFS filesystem.

The system can optionally have the root directory wiped after every reboot. Such a setup is possible because
NixOS only needs `/boot` and `/nix` in order to boot, all other system files are simply links to files in `/nix`.

## Partitioning

First thing we will need to do is set up partitions. To do so, I recommend using `fdisk`.
Assuming you have a single-disk system, you will want to create 3 partitions:

- EFI (1 GB)
- Swap (same size as your RAM, or more)
- Data (rest)

The swap partition is optional, however I do recommend creating it (instead of using a swap file), as it will allow you to hibernate your machine.

> [!IMPORTANT]
> Don't forget to also set the type for these partitions (`t` command in `fdisk`).
> Most importantly for the EFI partition, as NixOS will fail to install if your boot partition
> doesn't have the EFI type. Although it is generally a good idea to also set a type for all
> of your partitions anyway.
>
> - EFI partition type: EFI System (1)
> - Swap partition type: Linux swap (19)
> - Data partition type: Linux filesystem (20)

### File-Systems

Now we'll to create file systems on these partitions, and give them disk labels:

```shell
mkfs.fat -F 32 /dev/sdX1
fatlabel /dev/sdX1 NIXBOOT

mkswap -L SWAP /dev/diskX2

cryptsetup luksFormat /dev/sdX3 --label NIXCRYPTFS
cryptsetup open /dev/disk/by-label/NIXCRYPTFS crypfs
mkfs.btrfs -L NIXFS /dev/mapper/cryptfs
```

### BTRFS Subvolumes

Now we will split our btrfs partition into the following subvolumes:

- root: The subvolume for `/`, which will be cleared on every boot.
- home: The subvolume for `/home`, which should be persisted across reboots and get backed up (snapshotting).
- nix: The subvolume for `/nix`, which needs to be persistent, but not worth snapshotting, as it's trivial to reconstruct.
- log: The subvolume for `/var/log`, which should be persisted, and optionally backed up.
- persist: The subvolume for `/persist`, containing system-wide state, which should be persisted and backed up.
- data: The subvolume for `/data`, containing my personal files, which should be persisted and backed up.

```shell
mount /dev/mapper/crypfs /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/data
```

We will now take a read-only snapshot of the root subvolume.
This snapshot will be eventually used for rolling back to on every boot (impermanence).

```shell
btrfs subvolume snapshot -r /mnt/root /mnt/root-blank
```

And finally, we can unmount the btrfs root.

```shell
umount /mnt
```

### Mount the partitions and subvolumes

> [!NOTE]
> Even though we're specifying the `compress` flag in the mount options of each btrfs subvolume,
> somewhat misleadingly, you can't actually use different compression levels for different subvolumes.
> Btrfs will share the same compression level across the whole partition, so it's pointless to attempt
> to set different values here.

> [!NOTE]
> You may have seen others use btrfs options such as `ssd`, `discard=async` and `space_cache=v2`.
> These are all default (with the `ssd` being auto-detected), so specifying them is pointless now.

```shell
mount -o subvol=root,compress=zstd:3,noatime /dev/mapper/cryptfs /mnt
mount --mkdir -o subvol=home,compress=zstd:3,noatime /dev/mapper/cryptfs /mnt/home
mount --mkdir -o subvol=nix,compress=zstd:3,noatime /dev/mapper/cryptfs /mnt/nix
mount --mkdir -o subvol=log,compress=zstd:3,noatime /dev/mapper/cryptfs /mnt/var/log
mount --mkdir -o subvol=persist,compress=zstd:3,noatime /dev/mapper/cryptfs /mnt/persist
mount --mkdir -o subvol=data,compress=zstd:3,noatime /dev/mapper/cryptfs /mnt/data

mount --mkdir /dev/disk/by-label/NIXBOOT /mnt/boot

swapon /dev/disk/by-label/SWAP
```

## Generate hardware configuration

NixOS can now automatically figure out the system configuration for you:

```shell
nixos-generate-config --root /mnt
```

This should result with `/mnt/etc/nixos/hardware-configuration.nix` being created.

We will now want to make some adjustments to this file. Let's first install neovim, because the minimal nix iso only
provides `nano`, and I simply refuse to use that software:

```shell
nix-env -iA nixos.neovim
nvim /mnt/etc/nixos/hardware-configuration.nix
```

### Disk labels

In here, you will notice that NixOS is using UUIDs instead of disk labels for mounting. You will want to adjust this, as
labels are more reliable, since they won't change if you move the disks around (like changing the sata ports). It also
makes the configuration much more readable.

You will see something like this:

```nix
boot.initrd.luks.devices."cryptfs".device = "/dev/disk/by-uuid/08047b54-10af-4579-bb58-6af549b5c13e";
```

Which you will want to change to:

```nix
boot.initrd.luks.devices."cryptfs".device = "/dev/disk/by-label/NIXCRYPTFS";
```

A bunch of entries for our btrfs partition:

```nix
fileSystems."/" =
    { device = "/dev/disk/by-uuid/61b2d710-2508-4849-9613-b52fbc62bcf5";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };
```

Where you will change the `device` like so:

```nix
fileSystems."/" =
    { device = "/dev/disk/by-label/NIXFS";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };
```

Do this for all BTRFS entries.

> [!NOTE]
> If you see the root file system (or any other) declared multiple times, it is safe to remove the duplicate definitions.

Now change the `/boot` partition entry from:

```nix
fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/6383-E5C1";
      fsType = "vfat";
    };
```

To:

```nix
fileSystems."/boot" =
    { device = "/dev/disk/by-label/NIXBOOT";
      fsType = "vfat";
    };
```

And finally the swap partition from:

```nix
swapDevices =
    [ { device = "/dev/disk/by-uuid/cb8cd9b7-8824-4a59-9249-89b5b2df0dbc"; }
    ];
```

To:

```nix
swapDevices =
    [ { device = "/dev/disk/by-label/SWAP"; }
    ];
```

### BTRFS options

You may notice that your mount options were not automatically picked up by the automatic config generation. That's
because NixOS hardware scanner isn't capable of detecting these. That means you will want to specify these options for
each BTRFS subvolume yourself. Let's add them:

```nix
fileSystems."/" =
    { device = "/dev/disk/by-label/NIXFS";
      fsType = "btrfs";
      options = [ "subvol=root" ];
    };
```

To the following:

```nix
fileSystems."/" =
    { device = "/dev/disk/by-label/NIXFS";
      fsType = "btrfs";
      options = [ "subvol=root" "noatime" "compress=zstd:3" ];
    };
```

(Make sure to not overwrite the `subvol` though, if you're copy-pasting)

### Subvolumes needed for boot

In order to correctly persist `/var/log`, the respective subvolume need to be mounted early enough in
the boot process. To do this, we will want to add `neededForBoot = true;`, so the entry will look like this:

```nix
fileSystems."/var/log" =
    { device = "/dev/disk/by-label/NIXFS";
      fsType = "btrfs";
      options = [ "subvol=log" "noatime" "compress=zstd:3" ];
      neededForBoot = true;
    };
```

Additionally, we will also need to add `neededForBoot = true;` to our `/persist` subvolume. This is because
we will be storing the root users password file in there.

## Minimal config

Although it is possible to customize `/etc/nixos/configuration.nix` at this point to set up all the things you need in
one fell swoop, I recommend starting out with a relatively minimal config, to make sure everything works ok. I went with
something like this, with a user called `itsdrike`:

```nix
{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "pc"; # Define your hostname
  networking.networkmanager.enable = true;

  # Define a user account.
  users.users.itsdrike = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable 'sudo' for the user.
  };

  # Install an actually usable editor
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
    viAlias = true;
  };

  # Enable SSH daemon
  # (uncomment if you want SSH immediately)
  #services.openssh = {
  #  enable = true;
  #  settings.PermitRootLogin = "yes";
  #};

  # Set this to the auto-generated value originally present in this file
  system.stateVersion = "23.11";
}
```

## Installation

Take a deep breath.

```shell
nixos-install
reboot
```

(Note: You will be asked for the root password at the end of `nixos-install`)

If all goes well, we'll be prompted for the passphrase to decrypt our disk, and then be greeted with the usual TTY login
screen. Log in as root, set your password (`passwd itsdrike`), log out and re-login as your unprivileged user.

## Automatic root subvolume wiping

This is an optional step, if you don't want your root partition to get auto-reset on each boot, you can simply skip this.

### Auto-restore root-blank snapshot

Remember how we create the empty snapshot of our root subvolume? Well now comes the time when we put it to use. We will
restore this snapshot from initrd, which runs in a temporary file-system, before our actual file-system is even mounted.
This makes it a perfect place to run a script which will restore our root subvolume to the blank snapshot before each
boot.

I will set this up using a systemd-based initrd, because I will need systemd for TPM unlocking later on. If you don't
care about that, it is also possible to do this without systemd. You can a guide for such setup
[here](https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html#darling-erasure). That said, I find this to be
a cleaner setup than the non-systemd one anyway, so it might be worth it for you to follow this regardless. However, do
note that using systemd in initrd may result in slightly slower boot times.

To achieve this, let's add the following to our `configuration.nix`:

```nix
boot.initrd.systemd = {
  enable = true; # This enables systemd support in stage 1 - required for below setup
  services.rollback = {
    description = "Rollback BTRFS root subvolume to a pristine state";
    wantedBy = [ "initrd.target" ];
    # make sure it's done after decryption (i.e. LUKS/TPM process)
    after = [ "systemd-cryptsetup@cryptfs.service" ];
    # mount the root fs before clearing
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt

      # We first mount the btrfs root to /mnt
      # so we can manipulate btrfs subvolumes.
      mount /dev/mapper/cryptfs /mnt

      # While we're tempted to just delete /root and create
      # a new snapshot from /root-blank, /root is already
      # populated at this point with a number of subvolumes,
      # which makes `btrfs subvolume delete` fail.
      # So, we remove them first.
      #
      # /root contains subvolumes:
      # - /root/var/lib/portables
      # - /root/var/lib/machines
      #
      # These are probably related to systemd-nspawn, but
      # since I don't use it, I'm not 100% sure.
      # Anyhow, deleting these subvolumes hasn't resulted in
      # any issues so far, except for fairly benign-looking
      # errors from systemd-tmpfiles.
      btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

      echo "restoring blank /root subvolume..."
      btrfs subvolume snapshot /mnt/root-blank /mnt/root

      # Once we're done rolling back to a blank snapshot,
      # we can unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };
};
```

### Impermanence

What this implies is that certain files, such as saved networks for network-manager will be deleted on each reboot.
While a little clunky, [Impermanence](https://github.com/nix-community/impermanence) is a great solution to our problem.

Impermanence adds a `environment.persistence."<dirName>"` option, that we can use to make certain directories or files
permanent. A sample configuration module for this can look like so:

```nix
{ config, pkgs, ... }:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports = [ "${impermanence}/nixos.nix" ];

  # Some people use /nix/persist/system instead, leaving the persistent files in /nix subvolume
  # I much prefer using a standalone subvolume for this though.
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos" # nixos configuration source
      "/etc/NetworkManager/system-connections" # saved network connections
      "/var/db/sudo" # keeps track of who got the sudo lecture already
      "/var/lib/systemd/coredump" # recorded coredumps
    ];
    files = [
      "/etc/machine-id"

      # ssh stuff
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # For some reason, NetworkManager needs this instead of the impermanence mode to not get screwed up
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/system/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/system/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/system/var/lib/NetworkManager/timestamps"
  ];
}
```

You can put this module in `/etc/nixos/impermanence.nix`, and add it to your `imports` in `configuration.nix`.
Additionally, you may also want to move the `boot.initrd.systemd` configuration to this file.
Alternatively, you can of course also extend your `configuration.nix` adding this in directly, and keeping
everything in the same place.

#### User configuration

Note that with impermanence, your user passwords will get erased too (with the `/etc/shadow` file). To avoid this,
you can create password files, which will contain the password hashes for each user:

```shell
mkpasswd -m sha-512 > /persist/system/passwords/root
mkpasswd -m sha-512 > /persist/system/passwords/itsdrike
```

And declare these in our `configuration.nix` or `impermanence.nix`

```nix
users = {
  # This option makes it that users are not mutable outside our configuration
  # If you are using impermanence, this will actually be the case regardless of this setting,
  # however, setting this explicitly is a good idea, because nix will warn us if
  # our users don't have passwords set
  mutableUsers = false;

  # Each existing user needs to have a password file defined here
  # otherwise, they will not be available to login.
  # These password files can be generated using the following command:
  # mkpasswd -m sha-512 > /persist/passwords/myuser
  users = {
    root = {
      # password file needs to be in a volume marked `neededForBoot = true`
      hashedPasswordFile = "/persist/passwords/root";
    };
    itsdrike = {
      hashedPasswordFile = "/persist/passwords/itsdrike";
    };
  };
};
```

#### Rebuild

Once you have declared all the files that you wish to persist, you can now rebuild your configuration for the next boot:

```shell
nixos-rebuild boot
```

While NixOS will take care of creating the specified symlinks, you will want to move the relevant files and directories
to where the symlinks are pointing at before rebooting.

```shell
mkdir -p /persist/system

mkdir -p /persist/system/etc/NetworkManager
cp -r {,/persist/system}/etc/NetworkManager/system-connections
sudo mkdir -p /persist/system/var/lib/NetworkManager
sudo cp /var/lib/NetworkManager/{secret_key,seen-bssids,timestamps}
... # Copy any other files/dirs you have configured
```

> [!NOTE]
> In case `/var/lib/NetworkManager/seen-bssids` doesn't (yet) exist, you can just create a file
> like this in it's place:
> `echo "[seen-bssids]" > /persist/system/var/lib/NetworkManager/seen-bssids`

Once you have copied all the files and directories that you wish to persist, we're ready. Brace yourself, and

```shell
reboot
```

### Why?

Honestly, why not?

Automatic root partition wiping will force you into declaring all of your files which you actually care about
persisting, which allows you to create incredibly small backups of only those files which actually matter. No more
creating backups of the entire file-system for absolutely no reason.

Additionally, doing this is just a great practice in general, as it will mean recreating your entire system from a clean
slate, from an immutable `/nix/store`, which means even in the unlikely case, that your system got affected by some kind
of malware, it will simply be gone after the next reboot. (Unless it affected the images in `/boot`, at which point all
bets are off.)

## Integrating my flake

Well, that was fun!

### Clonning

Now, let's move this config over to my flake, creating a new host machine there. Unless you're me, you will want to fork
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

### Setting up git for new commits

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

### Moving config over

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

### Adjusting some things

Once moved, assuming you get rid of most of the settings in `default.nix`, as my flake will
handle setting almost everything up for you. Instead, you can use my custom options to declare almost everything.
The resulting file should then look something like this:

```nix
{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./impermanence.nix
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
    };
    device = {
      virtual-machine = false;
      cpu.type = "intel";
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

> [!WARNING]
> I'm currently working on making impermanence config in my flake directly. This will mean you will eventually be
> expected to just enable impermanence through myOptions. Right now, the config above includes `impermanence.nix`
> that we have enabled earlier. This will work, however note that flakes are a bit stricter with fetchTarball, and
> require a sha256 hash to be specified. You can specify it, or use the `--impure` flag for now. Once impermanence
> will be integrated into my flake, it will be handled as an input, and you won't have to worry about anything.

### Commit and switch

Once you've declared everything, make a commit and run `nix flake check` to make sure you everything checks out,
and you didn't make any typos or other issues.

```shell
git add hosts
git commit -m "Add anduril host"
nix flake check .
```

Finally, you should now be ready to switch:

```shell
sudo nixos-rebuild switch --flake .
```

If everything went well, you should now be left with a system configured to my specification.

### Last steps

Now that you've managed set up my flake, there are a few last steps to take.

First, you will probably now still be in a bash shell, I however use zsh, so you will want to re-login.

### Neovim

> [!WARNING]
> If you're logged in through SSH, you will need to set up a key based authentication,
> since password auth for SSH is disabled in my flake.

Once in zsh, another important step to set up neovim. Since I use a custom configuration, which relies on a lot of
plugins and other utilities, you will want to run neovim in headless mode for the first time, and leave it to install
all of these automatically:

```shell
nvim --headless +q
```

Once this completes, run neovim. Note that you will still see Mason installing a bunch of tools now, which will cause a
lot of notifications. Don't be alarmed by that, it is normal. Once the notifications stop, the installation process will
be truly complete. You can then close neovim.

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

## Sources / Attribution

- <https://nixos.wiki/wiki/Btrfs>
- <https://www.reddit.com/r/NixOS/comments/qys6xw/btrfs_recommendation/>
- <https://wiki.tnonline.net/w/Btrfs/Mount_Options>
- <https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html>
- <https://git.notashelf.dev/NotAShelf/nyx/src/branch/main/docs/notes/2023-03-14-impermanence.md>
- <https://nixos.wiki/wiki/NixOS_Installation_Guide>
- <https://nixos.wiki/wiki/Impermanence>

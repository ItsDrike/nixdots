# Installation

This installation guide will walk you through the process of setting up NixOS, going from the minimal ISO to a fully
configured system.

This guide is written primarily as a reference for myself, but it can certainly be a useful resource for you if you're
new to NixOS, and you want to set everything up yourself. I have purposefully not used my flake here, and I instead show
a setup that follows a fairly minimal configuration, to allow anyone to use this guide as a starting step to creating
their own configuration.

This guide is split into multiple files, some of which are skippable/optional. This file will show you how to get from
the minimal ISO to a very simple almost blank NixOS system. This configuration will involve setting up LUKS encryption
with BTRFS file-system, and assumes a single drive. However, it should be fairly easy to adjust things, set up
additional drives, etc.

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

> [!NOTE]
> For the LUKS encrypted partitions, I'd heavily recommend that you back up the LUKS headers in case of a partial drive failure, so that you're still
> able to recover your remaining data. To do this, you can use the following command:
>
> ```bash
> cryptsetup luksHeaderBackup /dev/device --header-backup-file /mnt/backup/file.img
> ```

### BTRFS Subvolumes

Now we will split our btrfs partition into the following subvolumes:

- root: The subvolume for `/`, which can be cleared on every boot.
- home: The subvolume for `/home`, which should be persisted across reboots and get backed up (snapshotting).
- nix: The subvolume for `/nix`, which needs to be persistent, but not worth snapshotting, as it's trivial to reconstruct.
- log: The subvolume for `/var/log`, which should be persisted, and optionally backed up.
- persist: The subvolume for `/persist`, containing system-wide state, which should be persisted and backed up.
- data: The subvolume for `/data`, containing my personal files, which should be persisted and backed up.

> [!TIP]
> If you do not wish to set up impermanence (wiping root partition after every boot), you won't need
> the persist subvolume. Depending on your preferences, you can also get rid of the `/var/log` subvolume.
>
> It is very easy to add new BTRFS subvolumes later on, or adjust existing ones (even removing is usually quite
> straightforward), so don't be too afraid if you don't yet know if the structure you go with will meet your needs.

```shell
mount /dev/mapper/crypfs /mnt
btrfs subvolume create /mnt/root
btrfs subvolume create /mnt/home
btrfs subvolume create /mnt/nix
btrfs subvolume create /mnt/log
btrfs subvolume create /mnt/persist
btrfs subvolume create /mnt/data
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
the boot process. To do this, we will want to add `neededForBoot = true;`. Additionally, if you will be
following up with impermanence, you will also need to add this parameter for our `/persist` subvolume.
This is because we will be storing the user password (including root password) in a password file there
(mentioned later on, in the impermanence guide).

So the entries will look like this:

```nix
fileSystems."/var/log" =
    { device = "/dev/disk/by-label/NIXFS";
      fsType = "btrfs";
      options = [ "subvol=log" "noatime" "compress=zstd:3" ];
      neededForBoot = true;
    };

fileSystems."/persist" =
    { device = "/dev/disk/by-label/NIXFS";
      fsType = "btrfs";
      options = [ "subvol=persist" "noatime" "compress=zstd:3" ];
      neededForBoot = true;
    };
```

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

You can now move on to the next file: [IMPERMANENCE](./02_IMPERMANENCE.md).

## Sources / Attribution

- <https://nixos.wiki/wiki/Btrfs>
- <https://www.reddit.com/r/NixOS/comments/qys6xw/btrfs_recommendation/>
- <https://nixos.wiki/wiki/NixOS_Installation_Guide>
- <https://wiki.tnonline.net/w/Btrfs/Mount_Options>

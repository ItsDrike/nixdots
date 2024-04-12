# Impermanence

The word impermanence means temporary or short-lived. When you see this term in NixOS, it refers to the practice
of automatically resetting/wiping your system after each reboot.

This will mean that your root directory will be wiped after every reboot. Such a setup is possible because
NixOS only needs `/boot` and `/nix` in order to boot, all other system files are simply links to files in `/nix`.

This guide assumes you're following from the [INSTALLATION](./01_INSTALLATION.md) guide, which means you have a working
setup with BTRFS file-system. Note that you will need the `/persist` and `/var/log` (and `/root`) subvolumes if you want
to proceed with this guide.

Note that setting up impermanence is completely optional, and if you do not wish to do so, you can simply skip this
guide and move on to the next one. If you're unsure whether impermanence is worth setting up, check out the
[Why section](#why).

## Auto-wipe root partition

To reset the root subvolume on every boot, we can simply delete it and create a new one in its place. We will be doing
this from initrd, which runs in a temporary file-system, before the actual file-system is properly mounted (following
fstab). This makes it a perfect place to run a script, which will wipe the root subvolume before each boot.

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
      # Mount the BTRFS root to /mnt so we can manipulate btrfs subvolumes
      mount --mkdir /dev/mapper/cryptfs /mnt

      # Simply deleting a subvolume with btrfs subvolume delete will not work,
      # if that subvolume contains other btrfs subvolumes. Because of that, we
      # instead use this function to delete subvolumes, whihc will first perform
      # a recursive deletion of any nested subvolumes.
      #
      # This is necessary, because the root subvolume will actually usually contain
      # other subvolumes, even if the user haven't created those explicitly. It seems
      # that NixOS creates these automatically. Namely, I observed these in root subvol:
      # - root/srv
      # - root/var/lib/portables
      # - root/var/lib/machines
      # - root/var/tmp
      delete_subvolume_recursively() {
        IFS=$'\n'
        for x in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/mnt/$x"
        done

        echo "Deleting subvolume $1"
        btrfs subvolume delete "$1"
      }

      # Recreate the root subvolume
      delete_subvolume_recursively "/mnt/root"
      echo "Re-creating root subvolume"
      btrfs subvolume create "/mnt/root"

      # we can now unmount /mnt and continue on the boot process.
      umount /mnt
    '';
  };
};
```

## Impermanence

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
    ];
  };

  # For some reason, NetworkManager needs this instead of the impermanence mode to not get screwed up
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/system/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/system/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/system/var/lib/NetworkManager/timestamps"
  ];

  # Define host key paths in the persistent mount point instead of using impermanence for these.
  # This works better, because these keys also get auto-created if they don't already exist.
  services.openssh.hostKeys = mkForce [
    {
      bits = 4096;
      path = "/persist/system/etc/ssh/ssh_host_rsa_key";
      type = "rsa";
    }
    {
      bits = 4096;
      path = "/persist/system/etc/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
  ];
}
```

You can put this module in `/etc/nixos/impermanence.nix`, and add it to your `imports` in `configuration.nix`.
Additionally, you may also want to move the `boot.initrd.systemd` configuration to this file.
Alternatively, you can of course also extend your `configuration.nix` adding this in directly, and keeping
everything in the same place.

### User configuration

Note that with impermanence, your user passwords will get erased too (with the `/etc/shadow` file). To avoid this,
you can create password files, which will contain the password hashes for each user:

```shell
mkdir -p /persist/passwords
chmod 700 /persist/passwords
mkpasswd -m sha-512 > /persist/passwords/root
mkpasswd -m sha-512 > /persist/passwords/itsdrike
chmod 600 /persist/passwords/*
```

And declare these in our `configuration.nix` or `impermanence.nix`

```nix
users = {
  # This option makes it that users are not mutable outside of our configuration.
  # If you're using root impermanence, this will actually be the case regardless
  # of this setting, however, setting this explicitly is a good idea, because nix
  # will warn us if our users don't have passwords set, preventing lock outs.
  mutableUsers = false;

  # Each existing user needs to have a password file defined here, otherwise
  # they will not be available to login. These password files can be generated with:
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

### Copy the configuration

While NixOS will take care of creating the specified symlinks, you will want to move the relevant files and directories
to where the symlinks are pointing at before rebooting.

```shell
mkdir -p /persist/system/etc
cp -r {,/persist/system}/etc/nixos

cp {,/persist/system}/etc/machine-id

mkdir -p /persist/system/var/db
cp -r {,/persist/system}/var/db/sudo

mkdir -p /persist/system/var/lib/systemd
cp -r {,/persist/system}/var/lib/systemd/coredump

mkdir -p /persist/system/etc/NetworkManager
cp -r {,/persist/system}/etc/NetworkManager/system-connections

sudo mkdir -p /persist/system/var/lib/NetworkManager
sudo cp {,/persist/system}/var/lib/NetworkManager/secret_key
sudo cp {,/persist/system}/var/lib/NetworkManager/timestamps
sudo cp {,/persist/system}/var/lib/NetworkManager/seen-bssids # if this fails, read the note below and repeat

... # Copy any other files/dirs you have configured
```

> [!NOTE]
> In case `/var/lib/NetworkManager/seen-bssids` doesn't (yet) exist, you can just create a file
> like this in it's place:
> `echo "[seen-bssids]" > /persist/system/var/lib/NetworkManager/seen-bssids`

## Rebuild

Once you have declared all the files that you wish to persist, you can now rebuild your configuration for the next boot,
and reboot.

> [!TIP]
> If you want to test out whether it worked, you can create a file somewhere on the root subvolume
> and make sure that it will no longer be there after the reboot: `touch /test_flag`

```shell
nixos-rebuild boot
reboot
```

You should now be back in your system, with the root subvolume wiped and auto-reconstructed by NixOS.

You can now move on to the next file: [SECURE_BOOT](./03_SECURE_BOOT.md).

## Why?

Honestly, why not?

Automatic root partition wiping will force you into declaring all of your files which you actually care about
persisting, which allows you to create incredibly small backups of only those files which actually matter. No more
creating backups of the entire file-system for absolutely no reason.

Additionally, doing this is just a great practice in general, as it will mean recreating your entire system from a clean
slate, from an immutable `/nix/store`, which means even in the unlikely case, that your system got affected by some kind
of malware, it will simply be gone after the next reboot. (Unless it affected the images in `/boot`, at which point all
bets are off.)

## Sources / Attribution

- <https://nixos.wiki/wiki/Impermanence>
- <https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html>
- <https://git.notashelf.dev/NotAShelf/nyx/src/branch/main/docs/notes/2023-03-14-impermanence.md>

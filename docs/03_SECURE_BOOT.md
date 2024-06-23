# Secure Boot

This guide will show you how to set up UEFI Secure Boot with NixOS. Once finished, you will be left with a system that
doesn't allow booting any untrusted EFI images (other operating systems, fraudulently modified kernels) on your machine.

This guide assumes you're following from the [INSTALLATION](./01_INSTALLATION.md) guide, and that
you have converted your config to a flake.

## Make sure you're using UEFI

As a first step, you will want to confirm that you really are on a UEFI system. If you're using any recent hardware,
this is very likely the case. Nevertheless, let's check and make sure:

```shell
bootctl status
```

Make sure the `Firmware` is reported as `UEFI`.

## Security requirements

The requirements are optional, as it is possible to set up secure boot without them. That said, they are heavily
encouraged, as without these, setting up secure boot will not be a very effective security measure.

First requirement is to set up a **BIOS Password**. This is a password that you will be asked for every time you wish to
enter the BIOS (UEFI). This is necessary, as without it, an attacker could very easily just go to the BIOS and disable
Secure Boot.

The second requirement is having **disk encryption**, at least for the root (or persist, if using impermanence)
partition. This is important, because the UEFI signing keys will be stored here, and you don't want someone to
potentially be able to get access to them, as it would allow them to sign any malicious images, making them pass secure
boot.

> [!NOTE]
> Even after following all of these, you should be aware that Secure Boot isn't an unbreakable solution. In
> fact, if someone is able to get a hold of your machine, they can simply pull out the CMOS battery, which usually
> resets the UEFI. That means turning off Secure Boot, and getting rid of the BIOS password.
>
> While Secure Boot is generally a good extra measure to have, it is by no means a reliable way to really prevent
> others from ever being able to boot untrusted systems, unless you use a specialized motherboard, which persists the
> UEFI state.

## Create your keys

To create secure boot keys, you can use `sbctl`, which is a very popular Secure Boot Key Manager. It is available in
nixpkgs as `pkgs.sbctl`. Make sure to add it to your configuration.

> [!IMPORTANT]
> If you have set up impermanence, you will first need to declare `/etc/secureboot` as a persistent directory. This
> directory will contain the secure boot keys necessary to sign the bootloader and your kernel/initrd images. If you
> lose this key, you will need to go through this process again.

Once you have sbctl installed, run the following command to create your new keys:

```shell
sudo sbctl create-keys
```

This takes a couple of seconds. When it is done, your Secure Boot keys are located in `/etc/secureboot`. sbctl sets the
permissions of the secret key so that only root can read it.

## lanzaboote

`lanzaboote` is a tool to help you set up secure boot in NixOS. To install it, you can add it as an input for your
flake:

```nix
lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };
```

And include the `lanzaboote.nixosModules.lanzaboote` module.

Now, you will want to add the following to your configuration:

```nix
# Lanzaboote replaces systemd-boot
boot.loader.systemd-boot.enable = lib.mkForce false;

boot.lanzaboote = {
  enable = true;
  pkiBundle = "/etc/secureboot";
};
```

You can now rebuild your system: `sudo nixos-rebuild switch --flake .`.

## Check that your machine is ready for secure-boot environment

After you rebuild your system, check `sudo sbctl verify` output. You should see it report all of your boot entries as
signed.

Note that files ending with `bzImage.efi` do not need to be signed.

### Manually sign an image

In case you'd ever need to do so, it is possible to sign an image manually with `sbctl`. To do so, you can run:

```shell
sbctl sign -s /boot/my_image.efi
```

The `-s` flag means save. This makes sure the files will be automatically re-signed when we update. (List of files to
re-sign will be stored in the secure boot database, in `/etc/secureboot`)

Note that you shouldn't really need to use this.

## Enabling secure boot

Now that NixOS is ready for secure-boot, we will set up firmware. At the end of this section, Secure Boot will be
enabled on your system and your firmware will only boot binaries that are signed with your keys.

### Enter Setup mode

To allow us to upload new signing keys into the UEFI firmware, we will need to enter "setup mode". This should be
possible by going to the Secure Boot category in your UEFI settings, and clicking on Delete/Clear certificates, or
there could even be a "Setup Mode" option directly.

This option may not be available without also enabling secure boot. This is fine, while in setup mode, the secure
boot checks will not be performed.

You can now save the settings and reboot.

Once booted, to check that you really are in Setup Mode, run:

```shell
sudo sbctl status
```

### Enroll the new keys

You will now have to enroll your new keys to activate Secure Boot.

```shell
sudo sbctl enroll-keys -m
```

> [!WARNING]
> The `-m` option (also known as `--microsoft`) will make sure to also include the Microsoft
> signing keys. This is required by most motherboards, not using it could brick your device.

> [!NOTE]
> If you encounter "File is immutable" warnings after running sbctl, it should be safe to simply add the `-i` (or
> `--ignore-immutable`) flag, which will run `chattr` and remove the immutable flags from these files for you.
>
> If you still encounter errors even with this flag, it means you have probably done something wrong when entering the
> setup mode. Try looking for a option like "Reset keys" in your UEFI, then try this again.

This should automatically enable secure boot in user mode for you. You can now **reboot the system**.

### Make sure it worked

To check that you really are using secure-boot, you can run

```shell
bootctl status
```

It should report `Secure Boot: enabled (user)`.

## Why bother?

As I mentioned, secure boot can be bypassed if someone tries hard enough (pulling the CMOS battery). That then
brings to question whether it's even worth it to set it up, when it doesn't really give you that much. On its own,

I probably wouldn't bother with setting up secure-boot, however secure boot allows me to set up TPM (Trusted Platform
Module) to automatically release the decryption keys for my LUKS encrypted root partition, in a secure way. This means I
won't have to type my disk password every time I boot.

For more information on this, check out the follow-up guide: [TPM_UNLOCKING](./04_TPM_UNLOCKING.md).

## Sources / Attribution

- <https://github.com/nix-community/lanzaboote/blob/master/docs/QUICK_START.md>

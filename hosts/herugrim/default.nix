{ lib, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems = [ "btrfs" ];

  # My flake disables this by default for security reasons. However,
  # with an encrypted setup, which requires entering password before
  # booting anyways, this is not a security concern, and changing the
  # kernel params can be useful for debugging.
  boot.loader.systemd-boot.editor = true;

  nix.settings = {
    max-jobs = 6;
    cores = 6;
  };

  # NixOS release from which this machine was first installed.
  # (for stateful data, like file locations and db versions)
  # Leave this alone!
  system.stateVersion = lib.mkForce "23.11";

  services.openssh.settings.PasswordAuthentication = lib.mkForce true;

  myOptions = {
    system = {
      hostname = "herugrim";
      username = "itsdrike";

      impermanence = {
        root = {
          enable = true;
          # Some people use /nix/persist/system for this, leaving persistent files in /nix subvolume
          # I much prefer using a standalone subvolume for this though.
          persistentMountPoint = "/persist";
        };

        # Configure automatic root subvolume wiping on boot from initrd
        autoWipeBtrfs = {
          enable = true;
          devices."/dev/disk/by-label/NIXROOT".subvolumes = [ "root" ];
        };
      };

      boot = {
        secure-boot.enable = true;
        tmpOnTmpfs = true;

        # Boot splash screen
        plymouth = {
          enable = true;
          withThemes = true;  # enable adi1090x/plymouth-themes
          selectedTheme = "colorful_loop";
        };
      };
    };

    device = {
      virtual-machine = false;
      cpu.type = "intel";
      hasTPM = true;
    };

    home-manager = {
      enable = true;
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

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

      sound.enable = true;
      bluetooth.enable = true;

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
      };
    };

    device = {
      roles = {
        type = "laptop";
        virtual-machine = false;
      };
      cpu.type = "amd";
      gpu.type = "hybrid-nvidia";
      hasTPM = true;
    };

    security = {
      auditd = {
        enable = true;
        autoPrune.enable = true;
      };
    };

    workstation = {
      printing.enable = true;
    };

    home-manager = {
      enable = true;
      stateVersion = "23.11";

      git = {
        userName = "ItsDrike";
        userEmail = "itsdrike@protonmail.com";
        signing = {
          enable = true;
          key = "FA2745890B7048C0";
        };
      };

      wms.hyprland = {
        enable = true;
        monitor = [
          "eDP-1, 1920x1080@60, 0x0, 1"
        ];
      };

      programs = {
        spotify.enable = true;
      };
    };
  };
}

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  boot.supportedFilesystems = [ "btrfs" ];
  hardware.enableAllFirmware = true;

  # My flake disables this by default for security reasons. However, with an encrypted setup,
  # which requires entering password before booting anyways, this is not a security concern, and
  # changing kernel params can be useful sometimes for debugging
  boot.loader.systemd-boot.editor = true;

  # CPU usage configuration for nix
  nix.settings = {
    max-jobs = 8;
    cores = 6;
  };

  # NixOS release from which this machine was first installed
  # (for stateful data, like file locations and db versions)
  # Leave this alone!
  system.stateVersion = "24.05";

  myOptions = {
    system = {
      hostname = "voyager";
      username = "itsdrike";

      sound.enable = true;
      bluetooth.enable = true;

      impermanence = {
        root = {
          enable = true;

          # Some people use /nix/persist/system for this, leaving persistent files in /nix subvolume
          # I much prefer using a standalone subvolume for this though.
          persistentMountPoint = "/persist";

          extraDirectories = [
            "/var/log"
          ];
        };

        home = {
          enable = true;
          persistentMountPoint = "/persist/home";
          extraDirectories = [
            "Downloads"
            "Personal"
            "Media"
            "dots"

            ".mozilla"
            ".mullvad"
            ".config/chromium"
            ".config/spotify"
            ".config/vesktop"
            ".local/share/gnupg"
            ".local/share/zoxide"
            ".local/share/wakatime"
            ".local/share/nvim"
            ".local/state/nvim"
            ".local/share/zsh"
            ".local/share/Smart Code ltd/Stremio"
            ".local/share/cargo"
            ".local/share/go"
          ];
          extraFiles = [
            ".config/git/git-credentials"
          ];
        };

        # Configure automatic root subvolume wiping on boot from initrd
        autoWipeBtrfs = {
          enable = true;
          devices."/dev/disk/by-label/NIXOS-FS".subvolumes = [ "root" ];
        };
      };
    };

    device = {
      roles = {
        type = "laptop";
	      virtual-machine = false;
      };
      cpu.type = "amd";
      gpu.type = "amd";
      hasTPM = true;
    };

    security = {
      auditd = {
        enable = true;
	      autoPrune.enable = true;
      };
    };

    workstation = {
      printing = {
        enable = true;
        hplip.enable = true;
      };
    };

    home-manager = {
      enable = true;
      stateVersion = "24.05";

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
	        # Primary / laptop display
	        "eDP-1, 1920x1200@60, 0x1080, 1"

          # HDMI-A-1 above primary
	        "HDMI-A-1, 1920x1080@60, 0x0, 1"

	        # HDMI-A-1 left to primary
	        #"HDMI-A-1, 1920x1080@60, 1920x1080, 1"

	        # Mirror the primary (laptop) monitor on externals
	        ", preferred, auto, 1, mirror, eDP-1"
	      ];
      };

      programs = {
        bars.eww.enable = true;
        browsers = {
          firefox.enable = true;
          chromium.enable = true;
          mullvad-browser.enable = true;
        };
        tools = {
          fastfetch.enable = true;
          hyfetch.enable = true;
        };
        spotify.enable = true;
        stremio.enable = true;
        vesktop = {
          enable = true;
          autoStart = true;
        };
      };
    };
  };
}

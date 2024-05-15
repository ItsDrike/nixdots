{ config, lib, pkgs, ... }:
let
  dev = config.myOptions.device;
in
{
  config = lib.mkIf (dev.gpu.type == "nvidia") {
    # Nvidia drivers are unfree software
    nixpkgs.config.allowUnfree = true;

    # Enable nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        # modeestting is required
        modesetting.enable = lib.mkDefault true;

        # Nvidia power managerment. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead of just
        # the bare essentials
        powerManagement.enable = lib.mkDefault true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer)
        powerManagement.finegrained = lib.mkDefault false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at: https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
        #
        # Enable this by default, hosts may override this option if their gpu is not 
        # supported by the open source drivers
        open = lib.mkDefault true;

        # Add the Nvidia settings package, accessible via `nvidia-settings`.
        # (useless on NixOS)
        nvidiaSettings = false;

        # This ensures all GPUs stay awake even during headless mode.
        nvidiaPersistenced = true;
      };

      # Enable OpenGL
      opengl = {
        enable = true;

        # VA-API implementation using NVIDIA's NVDEC
        extraPackages = with pkgs; [nvidia-vaapi-driver];
        extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
      };
    };

    # blacklist nouveau module so that it does not conflict with nvidia drm stuff
    # also the nouveau performance is horrible in comparison.
    boot.blacklistedKernelModules = ["nouveau"];

    environment = {
      systemPackages = with pkgs; [
        mesa

        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        libva
        libva-utils
      ];

      sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        WLR_NO_HARDWARE_CURSORS = "1";
      };
    };
  };
}

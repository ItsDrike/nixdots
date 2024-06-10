{ config, lib, pkgs, ... }:
let
  dev = config.myOptions.device;
  isWayland = config.myOptions.home-manager.wms.isWayland;

  inherit (lib) mkIf mkDefault mkMerge;
in
{
  config = mkIf (builtins.elem dev.gpu.type ["nvidia" "hybrid-nvidia"]) {
    # Nvidia drivers are unfree software
    nixpkgs.config.allowUnfree = true;

    # Enable nvidia driver for Xorg and Wayland
    services.xserver.videoDrivers = ["nvidia"];

    # blacklist nouveau module so that it does not conflict with nvidia drm stuff
    # also the nouveau performance is horrible in comparison.
    boot.blacklistedKernelModules = ["nouveau"];

    hardware = {
      nvidia = {
        # modeestting is required
        modesetting.enable = mkDefault true;

        # Nvidia power managerment. Experimental, and can cause sleep/suspend to fail.
        # Enable this if you have graphical corruption issues or application crashes after waking
        # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead of just
        # the bare essentials
        powerManagement.enable = mkDefault true;

        # Fine-grained power management. Turns off GPU when not in use.
        # Experimental and only works on modern Nvidia GPUs (Turing or newer)
        powerManagement.finegrained = mkDefault false;

        # Use the NVidia open source kernel module (not to be confused with the
        # independent third-party "nouveau" open source driver).
        # Support is limited to the Turing and later architectures. Full list of
        # supported GPUs is at: https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
        #
        # Enable this by default, hosts may override this option if their gpu is not 
        # supported by the open source drivers
        open = mkDefault true;

        # Add the Nvidia settings package, accessible via `nvidia-settings`.
        # (useless on NixOS)
        nvidiaSettings = mkDefault false;

        # This ensures all GPUs stay awake even during headless mode.
        nvidiaPersistenced = true;

        # On Hybrid setups, using Nvidia Optimus PRIME is necessary
        #
        # There are various options/modes prime can work in, this will default to
        # using the offload mode, which will default to running everything on igpu
        # except apps that run with certain environmental variables set. To simplify
        # things, this will also enable the `nvidia-offload` wrapper script/command.
        prime.offload = let
          isHybrid = dev.gpu.type == "hybrid-nvidia";
        in {
          enable = isHybrid;
          enableOffloadCmd = isHybrid;
        };
      };

      # Enable OpenGL
      opengl = {
        enable = true;

        # VA-API implementation using NVIDIA's NVDEC
        extraPackages = with pkgs; [nvidia-vaapi-driver];
        extraPackages32 = with pkgs.pkgsi686Linux; [nvidia-vaapi-driver];
      };
    };

    environment = {
      systemPackages = with pkgs; [
        mesa

        vulkan-tools
        vulkan-loader
        vulkan-validation-layers
        vulkan-extension-layer

        libva
        libva-utils

        glxinfo
      ];

      sessionVariables = mkMerge [
        { LIBVA_DRIVER_NAME = "nvidia"; }

        (mkIf isWayland {
          WLR_NO_HARDWARE_CURSORS = "1";
        })

        # Run the compositor itself with nvidia GPU?
        # Currently disabled
        (mkIf (isWayland && (dev.gpu == "hybrid-nvidia")) {
          #__NV_PRIME_RENDER_OFFLOAD = "1";
          #WLR_DRM_DEVICES = mkDefault "/dev/dri/card1:/dev/dri/card0";
        })
      ];
    };
  };
}

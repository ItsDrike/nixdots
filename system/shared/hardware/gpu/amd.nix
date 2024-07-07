# WARNING: This file is currently untested 
# (I didn't yet run this NixOS config on any AMD GPU systems)
{ config, lib, pkgs, ... }:
let
  dev = config.myOptions.device;
in
{
  config = lib.mkIf (dev.gpu.type == "amd") {
    services.xserver.videoDrivers = lib.mkDefault ["modesetting" "amdgpu"];

    boot = {
      initrd.kernelModules = ["amdgpu"];  # load amdgpu kernel module as early as initrd
      kernelModules = ["amdgpu"]; # if loading somehow fails during initrd but the boot continues, try again later
    };

    environment.systemPackages = with pkgs; [
      mesa

      vulkan-tools
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];

    hardware = {
      graphics = {
        enable = true;

        # Enable AMDVLK (AMD's open-source Vulkan driver)
        extraPackages = with pkgs; [ amdvlk ];
        extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
      };

      # OpenCL (Universal GPU computing API - not AMD specific)
      # To check if this works, run: `nix run nixpkgs#clinfo` (after rebooting)
      opengl.extraPackages = with pkgs; [rocmPackages.clr.icd];
    };

    # HIP (SDK that allows running CUDA code on AMD GPUs)
    # Most software has the paths hard-coded
    systemd.tmpfiles.rules = [
        "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];
  };
}

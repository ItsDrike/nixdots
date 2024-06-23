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

    # Enable OpenGL
    hardware.graphics = {
      enable = true;

      # Enable OpenCL and AMDVLK
      extraPackages = with pkgs; [ amdvlk ];
      extraPackages32 = with pkgs; [ driversi686Linux.amdvlk ];
    };
  };
}

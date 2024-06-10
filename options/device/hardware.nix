{ lib, ... }: with lib; let
in
{
  options.myOptions.device = {
    cpu.type = mkOption {
      type = with types; nullOr (enum [ "intel" "amd" ]);
      default = null;
      description = ''
        The manifaturer/type of the primary system CPU.

        Determines which ucode services will be enabled and provides additional kernel packages.
        If running in a virtual machine with forwarded/shared cores (CPU passthrough), use the
        cpu type of the host machine.
      '';
    };

    gpu.type = mkOption {
      type = with types; nullOr (enum [ "nvidia" "amd" "intel" "hybrid-nvidia" "hybrid-amd" ]);
      default = null;
      description = ''
        The manifaturer/type of the primary system GPU.

        Allows the correct GPU drivers to be loaded, potentially optimizing video output performance.

        If you're on a hybrid system (intel/amd igpu + nvidia/amd dgpu) make sure to use
        the hybrid options, only specifying the dgpu will not work properly.

        Note that if using hybrid-nvidia, you will need to set `hardware.nvidia.prime.nvidiaBusId`
        and `intelBusId` (or `amdgpuBusId`) to "PCI:x:y:z". To find the correct bus IDs, you can
        use `sudo lshw -c display`. Note that you will need to convert the bus ID format from
        hexadecimal to decimal, remove the padding (leading zeroes) and replace the dot with a
        colon (so for example 0e:00.0 -> PCI:14:0:0).
      '';
    };

    hasTPM = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Does this device have a TPM (Trusted Platform Module)?";
    };
  };
}

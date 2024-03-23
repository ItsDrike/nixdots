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

    virtual-machine = mkOption {
      type = lib.types.bool;
      default = false;
      description = "Is this system a virtual machine?";
    };
  };
}

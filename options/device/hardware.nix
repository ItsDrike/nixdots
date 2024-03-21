{ lib, ... }: with lib; let
in
{
  options.myOptions.device = {
    cpu.type = mkOption {
      type = with types; nullOr (enum [ "intel" "vm-intel" "amd" "vm-amd" ]);
      default = null;
      description = ''
        The manifaturer/type of the primary system CPU.

        Determines which ucode services will be enabled and provides additional kernel packages.
        If running in a virtual machine with forwarded/shared cores, use the `vm-` prefix.
      '';
    };
  };
}

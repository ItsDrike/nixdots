{ config, pkgs, ... }:
let
  impermanence = builtins.fetchTarball "https://github.com/nix-community/impermanence/archive/master.tar.gz";
in
{
  imports = [ "${impermanence}/nixos.nix" ];

  users = {
    # This option makes it that users are not mutable outside our configuration
    # If you are using impermanence, this will actually be the case regardless of this setting,
    # however, setting this explicitly is a good idea, because nix will warn us if
    # our users don't have passwords set
    mutableUsers = false;
  
    # Each existing user needs to have a password file defined here
    # otherwise, they will not be available to login.
    # These password files can be generated using the following command:
    # mkpasswd -m sha-512 > /persist/system/passwords/myuser
    users = {
      root = {
        # password file needs to be in a volume marked `neededForRoot = true`
        hashedPasswordFile = "/persist/passwords/root";
      };
      itsdrike = {
        hashedPasswordFile = "/persist/passwords/itsdrike";
      };
    };
  };

  # Some people use /nix/persist/system instead, leaving the persistent files in /nix subvolume
  # I much prefer using a standalone subvolume for this though.
  environment.persistence."/persist/system" = {
    hideMounts = true;
    directories = [
      "/etc/nixos" # nixos configuration source
      "/etc/NetworkManager/system-connections" # saved network connections
      "/var/db/sudo" # keeps track of who got the sudo lecture already
      "/var/lib/systemd/coredump" # recorded coredumps
    ];
    files = [
      "/etc/machine-id"

      # ssh stuff
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };

  # For some reason, NetworkManager needs this instead of the impermanence mode to not get screwed up
  systemd.tmpfiles.rules = [
    "L /var/lib/NetworkManager/secret_key - - - - /persist/system/var/lib/NetworkManager/secret_key"
    "L /var/lib/NetworkManager/seen-bssids - - - - /persist/system/var/lib/NetworkManager/seen-bssids"
    "L /var/lib/NetworkManager/timestamps - - - - /persist/system/var/lib/NetworkManager/timestamps"
  ];

  boot.initrd.systemd = {
    enable = true; # This enables systemd support in stage 1 - required for below setup
    services.rollback = {
      description = "Rollback BTRFS root subvolume to a pristine state";
      wantedBy = [ "initrd.target" ];
      # make sure it's done after decryption (i.e. LUKS/TPM process)
      after = [ "systemd-cryptsetup@cryptfs.service" ];
      # mount the root fs before clearing
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt
  
        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount /dev/mapper/cryptfs /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines
        #
        # These are probably related to systemd-nspawn, but
        # since I don't use it, I'm not 100% sure.
        # Anyhow, deleting these subvolumes hasn't resulted in
        # any issues so far, except for fairly benign-looking
        # errors from systemd-tmpfiles.
        btrfs subvolume list -o /mnt/root |
          cut -f9 -d' ' |
          while read subvolume; do
            echo "deleting /$subvolume subvolume..."
            btrfs subvolume delete "/mnt/$subvolume"
          done &&
          echo "deleting /root subvolume..." &&
          btrfs subvolume delete /mnt/root
  
        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root
  
        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };
  };
}


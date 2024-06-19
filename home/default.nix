{ config, lib, inputs, self, ... }:
let
  myHmConf = config.myOptions.home-manager;
  username = config.myOptions.system.username;
in
{
  home-manager = lib.mkIf myHmConf.enable {
    # Use verbose mode for home-manager
    verbose = true;

    # Should home-manager use the same pkgs as system's pkgs?
    # If disabled, home-manager will independently evaluate and use
    # its own set of packages. Note that this could increase disk usage
    # and it might lead to inconsistencies.
    useGlobalPkgs = true;

    # Use NixOS user packages (users.users.<name>.packages)
    # instead of home-manager's own shell init config files to
    # get packages to install
    useUserPackages = true;

    # Move existing files to .old suffix rather than exiting with error
    backupFileExtension = "hm.old";

    # These will be passed to all hm modules
    extraSpecialArgs = { inherit inputs self; };

    users.${username} = {
      # These imports will be scoped under this key so all settings
      # in them will be added to `home-manager.users.${username}`..
      imports = [
        ./packages
        ./programs
        ./impermanence
      ];

      config = {
        # Let home-manager manage itself in standalone mode
        programs.home-manager.enable = true;

        # Basic user config
        home = {
          inherit username;
          homeDirectory = "/home/${username}";
          stateVersion = myHmConf.stateVersion;
        };
      };
    };
  };
}

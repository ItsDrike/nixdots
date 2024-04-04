{ config, ... }: {
  programs = {
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";

      # I manage the keys manually
      mutableKeys = true;
      mutableTrust = true;

      settings = {
        keyserver = "hkps://keys.openpgp.org";

        # Don't leak information in signature
        no-emit-version = "";
        no-comments = "";
        export-options = "export-minimal";

        # Display the long format of the key ID and show fingerprints by default
        keyid-format = "0xlong";
        with-fingerprint = "";

        # Display UID validity of the keys
        list-options = "show-uid-validity";
        verify-options = "show-uid-validity";
      };
    };
  };
}

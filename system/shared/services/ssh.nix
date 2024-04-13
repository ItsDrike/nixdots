{ ... }: {
  # TODO: This really shouldn't be a default service in system/
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      X11Forwarding = false;
    };
  };
}


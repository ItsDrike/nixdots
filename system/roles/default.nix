{
  # We import all of the roles here, with the type checks being handled
  # in the individual files each time. This is a bit ugly, but necessary
  # as NixOS doesn't support optional imports, due to circual imports
  # (there might be a change of the config value inside one of the
  # imported files).
  imports = [
    ./workstation
    ./laptop
  ];
}

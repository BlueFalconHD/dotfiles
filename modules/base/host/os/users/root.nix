{config, ...}: {
  users.users.root = {
    hashedPasswordFile = config.sops.secrets.user-root-password.path;

    openssh.authorizedKeys.keys = [
      ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQDiHbMSinj8twL9cTgPOfI6OMexrTZyHX27T8gnMj2''
    ];
  };
}

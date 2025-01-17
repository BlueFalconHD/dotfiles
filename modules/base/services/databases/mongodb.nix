{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;

  cfg = config.modules.services.database.mongodb;
in {
  config = mkIf cfg.enable {
    services.mongodb = {
      enable = true;
      package = pkgs.mongodb;
      enableAuth = true;
      initialRootPassword = config.sops.secrets.mongodb-passwd.path;
      #bind_ip = cfg.host;
      extraConfig = ''
        operationProfiling.mode: all
      '';
    };
  };
}

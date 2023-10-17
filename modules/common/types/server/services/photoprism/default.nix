{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (config.networking) domain;
  cfg = config.modules.services.photoprism;
in {
  services = lib.mkIf cfg.enable {
    photoprism = {
      enable = true;
      port = 2342;
      originalsPath = "/var/lib/private/photoprism/originals";
      address = "0.0.0.0";
      settings = {
        PHOTOPRISM_ADMIN_USER = "admin";
        PHOTOPRISM_ADMIN_PASSWORD = "L38*%puzpXX!j$7!";
        PHOTOPRISM_DEFAULT_LOCALE = "en";
        PHOTOPRISM_DATABASE_DRIVER = "mysql";
        PHOTOPRISM_DATABASE_NAME = "photoprism";
        PHOTOPRISM_DATABASE_SERVER = "/run/mysqld/mysqld.sock";
        PHOTOPRISM_DATABASE_USER = "photoprism";
        PHOTOPRISM_SITE_URL = "https://photos.${domain}";
        PHOTOPRISM_SITE_TITLE = "My PhotoPrism";
      };
    };
    mysql = {
      enable = true;
      dataDir = "/data/mysql";
      package = pkgs.mariadb;
      ensureDatabases = ["photoprism"];
      ensureUsers = [
        {
          name = "photoprism";
          ensurePermissions = {
            "photoprism.*" = "ALL PRIVILEGES";
          };
        }
      ];
    };
  };
}

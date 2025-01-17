{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkForce mkIf;
  inherit (config.modules) device;
in {
  imports = [./fail2ban.nix];

  config = {
    # enable opensnitch firewall
    # inactive until opensnitch UI is opened
    services.opensnitch.enable = true;

    networking = {
      firewall = {
        enable = true;
        package = pkgs.iptables;
        allowedTCPPorts = [
          443
          8080
        ];
        allowedUDPPorts = [];
        allowedTCPPortRanges = mkIf (device.type != "server") [
          {
            #KDEconnect
            from = 1714;
            to = 1764;
          }
        ];
        allowedUDPPortRanges = mkIf (device.type != "server") [
          {
            #KDEconnect
            from = 1714;
            to = 1764;
          }
        ];
        allowPing = device.type == "server";
        logReversePathDrops = true;
        logRefusedConnections = false;
        checkReversePath = mkForce false; # Don't filter DHCP packets, according to nixops-libvirtd
      };
    };
  };
}

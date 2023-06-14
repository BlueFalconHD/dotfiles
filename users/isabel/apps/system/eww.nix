{
  pkgs,
  lib,
  ...
}: let
  mkService = lib.recursiveUpdate {
    Unit.PartOf = ["graphical-session.target"];
    Unit.After = ["graphical-session.target"];
    Install.WantedBy = ["graphical-session.target"];
  };
in {
  home.packages = with pkgs; [
    eww-wayland
    socat
    jaq
    acpi
    wlsunset
    wl-gammactl
    upower
    inotify-tools
    gtk3 pango cairo harfbuzz gdk-pixbuf
    blueberry gnome.gnome-bluetooth 
    networkmanagerapplet
  ];

  programs.eww = {
    enable = true;
    package = pkgs.eww-wayland;
    configDir = ../../config/eww;
  };
}
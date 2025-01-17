{lib, ...}: let
  inherit (lib) mkOption types mdDoc;
in {
  options.modules.programs.defaults = {
    terminal = mkOption {
      type = types.enum ["alacritty" "kitty" "wezterm" "foot"];
      default = "kitty";
    };

    fileManager = mkOption {
      type = types.enum ["thunar" "dolphin" "nemo"];
      default = "thunar";
    };

    browser = mkOption {
      type = types.enum ["schizofox" "chromium"];
      default = "chromium";
    };

    editor = mkOption {
      type = types.enum ["nvim" "codium"];
      default = "nvim";
    };

    launcher = mkOption {
      type = with types; nullOr (enum ["rofi" "wofi"]);
      default = "rofi";
    };

    bar = mkOption {
      type = with types; nullOr (enum ["eww" "waybar" "ags"]);
      default = "eww";
    };

    screenLocker = mkOption {
      type = with types; nullOr (enum ["swaylock" "gtklock"]);
      default = "gtklock";
      description = mdDoc ''
        The lockscreen module to be loaded by home-manager.
      '';
    };

    noiseSupressor = mkOption {
      type = with types; nullOr (enum ["rnnoise" "noisetorch"]);
      default = "rnnoise";
      description = mdDoc ''
        The noise supressor to be used for desktop systems with sound enabled.
      '';
    };
  };
}

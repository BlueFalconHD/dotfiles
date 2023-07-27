{
  osConfig,
  lib,
  ...
}:
with lib; let
  programs = osConfig.modules.programs;
  device = osConfig.modules.device;

  acceptedTypes = ["desktop" "laptop" "lite" "hybrid"];
in {
  config = mkIf ((builtins.elem device.type acceptedTypes) && (programs.cli.enable)) {
    programs.btop = {
      enable = true;
      catppuccin.enable = true;
      settings = {
        # color_theme = "catppuccin_mocha";
        vim_keys = true;
        rounded_corners = true;
      };
    };
  };
}
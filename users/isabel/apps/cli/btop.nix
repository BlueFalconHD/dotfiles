{
  config,
  pkgs,
  ...
}: {
  home.packages = [ pkgs.btop ];
  
  xdg.configFile."btop/themes/catppuccin_mocha.theme".text = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "btop";
      rev = "ecb8562bb6181bb9f2285c360bbafeb383249ec3";
      sha256 = "sha256-ovVtupO5jWUw6cwA3xEzRe1juUB8ykfarMRVTglx3mk=";
    }
    + "/catppuccin_mocha.theme");
  xdg.configFile."btop/themes/catppuccin_latte.theme".text = builtins.readFile (pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "btop";
      rev = "ecb8562bb6181bb9f2285c360bbafeb383249ec3";
      sha256 = "sha256-ovVtupO5jWUw6cwA3xEzRe1juUB8ykfarMRVTglx3mk=";
    }
    + "/catppuccin_latte.theme");

  programs.btop = {
    enable = true;
    settings = {
      color_theme = "catppuccin_mocha";
      vim_keys = true;
      rounded_corners = true;
    };
  };
}
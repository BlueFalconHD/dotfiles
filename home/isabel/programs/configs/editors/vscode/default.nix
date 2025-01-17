{
  lib,
  pkgs,
  osConfig,
  config,
  ...
}: let
  inherit (osConfig.modules.environment) flakePath;
  inherit (osConfig.modules.system) mainUser;
in {
  config = lib.mkIf osConfig.modules.programs.agnostic.editors.vscode.enable {
    programs.vscode = {
      enable = true;
      package = pkgs.vscode;
      extensions = with pkgs.vscode-extensions; [
        # THEMEING
        catppuccin.catppuccin-vsc-icons
        (pkgs.catppuccin-vsc.override {
          accent = "sapphire";
          boldKeywords = true;
          italicComments = true;
          italicKeywords = true;
          extraBordersEnabled = false;
          workbenchMode = "flat";
          bracketMode = "rainbow";
          colorOverrides = {};
          customUIColors = {};
        })

        # GIT
        github.copilot
        github.copilot-chat
        github.vscode-pull-request-github
        github.vscode-github-actions
        eamodio.gitlens

        # UTILITIES
        ms-vscode-remote.remote-ssh
        ms-vscode.live-server
        vscodevim.vim #yes i hate myself
        wakatime.vscode-wakatime

        # LANGUAGES BASED EXTENSIONS
        ## NIX
        jnoortheen.nix-ide
        kamadorueda.alejandra
        mkhl.direnv

        ## RUST
        serayuzgur.crates
        rust-lang.rust-analyzer

        ## GO
        golang.go

        ## LUA
        sumneko.lua

        ## TOML
        tamasfe.even-better-toml

        ## WEB DEV
        ### GENERAL
        bradlc.vscode-tailwindcss
        dbaeumer.vscode-eslint
        denoland.vscode-deno

        ### PHP
        devsense.phptools-vscode

        ### MARKDOWN
        shd101wyy.markdown-preview-enhanced
        unifiedjs.vscode-mdx
        valentjn.vscode-ltex
      ];
      mutableExtensionsDir = true;
    };

    xdg.configFile = {
      "VSCode/User/keybindings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/${mainUser}/programs/configs/editors/vscode/keybindings.json";
      "VSCode/User/settings.json".source = config.lib.file.mkOutOfStoreSymlink "${flakePath}/home/${mainUser}/programs/configs/editors/vscode/settings.json";
    };
  };
}

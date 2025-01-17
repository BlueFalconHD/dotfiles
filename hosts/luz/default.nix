_: {
  imports = [
    ./hardware-configuration.nix
    ./mount.nix
    ./overrides.nix
    ./services.nix
  ];

  config.modules = {
    device = {
      type = "server";
      cpu = "amd";
      gpu = null;
      hasTPM = false;
      hasBluetooth = false;
      hasSound = false;
    };
    system = {
      mainUser = "isabel";

      boot = {
        loader = "grub";
        enableKernelTweaks = true;
        initrd.enableTweaks = true;
        loadRecommendedModules = true;
      };

      fs = ["vfat" "exfat" "ext4"];
      video.enable = false;
      sound.enable = false;
      bluetooth.enable = false;
      printing.enable = false;

      networking = {
        optimizeTcp = false;

        tailscale = {
          enable = true;
          isServer = true;
          isClient = false;
        };
      };

      virtualization = {
        enable = true;
        docker.enable = false;
        qemu.enable = false;
        podman.enable = false;
        distrobox.enable = false;
      };
    };

    environment.useHomeManager = true;

    programs = {
      agnostic.git.signingKey = "B4D9D513B1560D99";

      cli = {
        enable = true;
        modernShell.enable = true;
      };
      tui.enable = true;
      gui.enable = false;
    };
  };
}

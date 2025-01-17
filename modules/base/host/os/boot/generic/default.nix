{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkForce mkOverride mkMerge mkIf optionals;
  sys = config.modules.system;
in {
  config = {
    boot = {
      consoleLogLevel = 0;

      # always use the latest kernel, love the unstablity
      kernelPackages = mkOverride 500 sys.boot.kernel;

      extraModulePackages = mkDefault sys.boot.extraModulePackages;
      extraModprobeConfig = mkDefault sys.boot.extraModprobeConfig;
      # whether to enable support for Linux MD RAID arrays
      # as of 23.11>, this throws a warning if neither MAILADDR nor PROGRAM are set
      swraid.enable = mkDefault false;

      # shared config between bootloaders
      # they are set unless system.boot.loader != none
      loader = {
        # if set to 0, space needs to be held to get the boot menu to appear
        timeout = mkForce 2;
        generationsDir.copyKernels = true;

        # we need to allow installation to modify EFI variables
        efi.canTouchEfiVariables = true;
      };

      # if you have a lack of ram, you should avoid tmpfs to prevent hangups while compiling
      tmp = {
        # /tmp on tmpfs, lets it live on your ram
        useTmpfs = sys.boot.tmpOnTmpfs;

        # If not using tmpfs, which is naturally purged on reboot, we must clean
        # we have to clean /tmp
        cleanOnBoot = mkDefault (!config.boot.tmp.useTmpfs);
      };

      # initrd and kernel tweaks
      # read what each parameter or module does before doing so, it will defo break something otherwise
      initrd = mkMerge [
        (mkIf sys.boot.initrd.enableTweaks {
          # Verbosity of the initrd
          # disabling verbosity removes only the mandatory messages generated by the NixOS
          verbose = false;

          # strip copied binaries and libraries from inframs
          # saves some nice space
          systemd.strip = true;

          # enable systemd in initrd (experimental)
          systemd.enable = true;

          # List of modules that are loaded by the initrd
          kernelModules = [
            "nvme"
            "xhci_pci"
            "ahci"
            "btrfs"
            "cifs"
            "sd_mod"
            "dm_mod"
            "tpm"
          ];

          # the set of kernel modules in the initial ramdisk used during the boot process
          availableKernelModules = [
            "usbhid"
            "sd_mod"
            "dm_mod"
            "uas"
            "usb_storage"
            "rtsx_pci_sdmmc" # Realtek SD card interface (btw i hate realtek)
          ];
        })

        (mkIf sys.boot.initrd.optimizeCompressor
          {
            compressor = "zstd";
            compressorArgs = ["-19" "-T0"];
          })
      ];

      # https://www.kernel.org/doc/html/latest/admin-guide/kernel-parameters.html
      kernelParams =
        (optionals sys.boot.enableKernelTweaks [
          # https://en.wikipedia.org/wiki/Kernel_page-table_isolation
          # auto means kernel will automatically decide the pti state
          "pti=auto" # on || off

          # disable the intel_idle (it stinks anyway) driver and use acpi_idle instead
          "idle=nomwait"

          # enable IOMMU for devices used in passthrough and provide better host performance
          "iommu=pt"

          # disable usb autosuspend
          "usbcore.autosuspend=-1"

          # isables resume and restores original swap space
          "noresume"

          # allow systemd to set and save the backlight state
          "acpi_backlight=native"

          # prevent the kernel from blanking plymouth out of the fb
          "fbcon=nodefer"

          # disable boot logo
          "logo.nologo"

          # disable systemd status messages
          # rd prefix means systemd-udev will be used instead of initrd
          "rd.systemd.show_status=auto"

          # lower the udev log level to show only errors or worse
          "rd.udev.log_level=3"

          # disable the cursor in vt to get a black screen during intermissions
          "vt.global_cursor_default=0"
        ])
        ++ (optionals sys.boot.silentBoot [
          # tell the kernel to not be verbose, the voices are too loud
          "quite"
        ]);
    };
  };
}

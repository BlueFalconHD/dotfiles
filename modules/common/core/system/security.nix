{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  sys = config.modules.system.security;
in {
  security = {
    protectKernelImage = true;
    lockKernelModules = false; # breaks virtd, wireguard and iptables

    # force-enable the Page Table Isolation (PTI) Linux kernel feature
    forcePageTableIsolation = true;

    # User namespaces are required for sandboxing. Better than nothing imo.
    allowUserNamespaces = true;

    apparmor = {
      enable = true;
      killUnconfinedConfinables = true;
      packages = [pkgs.apparmor-profiles];
    };

    virtualisation = {
      #  flush the L1 data cache before entering guests
      flushL1DataCache = "always";
    };

    auditd.enable = true;
    audit = {
      enable = true;
      rules = [
        "-a exit,always -F arch=b64 -S execve"
      ];
    };

    pam = {
      loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];

      services = {
        swaylock = {
          text = ''
            auth include login
          '';
        };
      };
    };

    sudo = {
      wheelNeedsPassword = false;
      enable = mkDefault true;
      execWheelOnly = true;
      extraConfig = ''
        # rollback results in sudo lectures after each reboot
        Defaults lecture = never
      '';
    };

    # doas is pretty wacky and interferes with nix's --remote-sudo
    doas = {
      enable = mkDefault (!config.security.sudo.enable);
      extraRules = [
        {
          groups = ["wheel"];
          persist = true;
          keepEnv = false;
        }
        {
          groups = ["power"];
          noPass = true;
          cmd = "${pkgs.systemd}/bin/poweroff";
        }
        {
          groups = ["power"];
          noPass = true;
          cmd = "${pkgs.systemd}/bin/reboot";
        }
        {
          groups = ["nix"];
          cmd = "nix-collect-garbage";
          noPass = true;
        }
        {
          groups = ["nix"];
          cmd = "nixos-rebuild";
          keepEnv = true;
        }
      ];
    };
  };

  boot.kernel.sysctl = {
    # The Magic SysRq key is a key combo that allows users connected to the
    # system console of a Linux kernel to perform some low-level commands.
    # Disable it, since we don't need it, and is a potential security concern.
    "kernel.sysrq" = 0;
    # Restrict ptrace() usage to processes with a pre-defined relationship
    # (e.g., parent/child)
    "kernel.yama.ptrace_scope" = 2;
    # Hide kptrs even for processes with CAP_SYSLOG
    "kernel.kptr_restrict" = 2;
    # Disable bpf() JIT (to eliminate spray attacks)
    "net.core.bpf_jit_enable" = false;
    # Disable ftrace debugging
    "kernel.ftrace_enabled" = false;
  };

  boot.blacklistedKernelModules =
    [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"
      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "bfs"
      "befs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "freevxfs"
      "f2fs"
      "vivid"
      "gfs2"
      "ksmbd"
      "nfsv4"
      "nfsv3"
      "cifs"
      "nfs"
      "cramfs"
      "freevxfs"
      "jffs2"
      "hfs"
      "hfsplus"
      "squashfs"
      "udf"
      "btusb"
      "hpfs"
      "jfs"
      "minix"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
    ]
    ++ lib.optionals (!sys.fixWebcam) [
      "uvcvideo" # this is why your webcam no worky
    ];
}
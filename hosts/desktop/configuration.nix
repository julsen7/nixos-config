{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # BOOTLOADER

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # GENERAL

  networking = {
    hostName = "desktop";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  zramSwap.enable = true;

  # LOCALISATION

  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "de_DE.UTF-8";
  console.keyMap = "de";

  services.xserver.xkb = {
    layout = "de";
    options = "eurosign:e,caps:escape";
  };

  # HARDWARE

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  hardware = {
    enableRedistributableFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = [ pkgs.obs-vkcapture ];
      extraPackages32 = [ pkgs.obs-vkcapture ];
    };
    nvidia = {
      modesetting.enable = true; # ?
      open = true;
      prime = {
        offload = {
          enable = true;
          enableOffloadCmd = true;
        };
        amdgpuBusId = "PCI:5@0:0:0";
        nvidiaBusId = "PCI:1@0:0:0";
      };
    };
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };
  };

  # SERVICES

  services.openssh.enable = true;
  services.gnome.gnome-keyring.enable = true;
  services.udisks2.enable = true;
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;

  services.displayManager.ly = {
    enable = true;
    settings = {
      animation = "matrix";
      dur_file_path = "blackhole.dur";
      bigclock = "en";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
  };

  # VIRTUALISATION

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
    };
  };

  programs.virt-manager.enable = true;

  # USER

  users.users.julsen = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "libvirtd" "kvm" ];
    hashedPassword = "$y$j9T$n8yEDLyG5/IORRV5SPJ5I.$KEdyBgQbDYMSWWxeZYgW/NpdKltwuBk7RZU7ydNzb5.";
  };

  # PACKAGES

  nixpkgs.config.allowUnfree = true;

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # NIX

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.auto-optimise-store = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  system.stateVersion = "26.05";
}

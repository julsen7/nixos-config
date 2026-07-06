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

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;

  zramSwap.enable = true;

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
    enableAllFirmware = true; # ?
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    nvidia = {
      open = true;
      prime = {
        offload.enable = true;
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
  services.ratbagd.enable = true;
  services.udisks2.enable = true;
  services.fwupd.enable = true;
  services.power-profiles-daemon.enable = true;

  services.displayManager.ly = {
    enable = true;
    wayland.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # USER

  users.users.julsen = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$y$j9T$n8yEDLyG5/IORRV5SPJ5I.$KEdyBgQbDYMSWWxeZYgW/NpdKltwuBk7RZU7ydNzb5.";
  };

  security.rtkit.enable = true; # ?

  # PACKAGES

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  boot.supportedFilesystems = [ "ntfs" ];
  security.polkit.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        ignore_empty_input = true;
      };

      animations = {
        enabled = true;
        fade_in = {
          duration = 300;
          bezier = "easeOutQuint";
        };
        fade_out = {
          duration = 300;
          bezier = "easeOutQuint";
        };
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "250, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = false;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 5;
          placeholder_text = '\'<span foreground="##cad3f5">Password...</span>'\';
          shadow_passes = 2;
        }
      ];
    };
  };

  system.stateVersion = "26.05";
}

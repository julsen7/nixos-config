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

  networking.hostName = "laptop";
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
  ];

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      enable32Bit = true;
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

  services.displayManager.ly.enable = true;

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
  
  security.rtkit.enable = true;
  security.polkit.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  system.stateVersion = "26.05";
}

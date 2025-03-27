{ config, lib, pkgs, ... }:

{
  imports =
    [
    ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ 
    "nix-command" 
    "flakes" 
  ]; 

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "nixpad";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Stockholm";

  services.displayManager.ly = {
    enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

# Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  users.users.oscar = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk];

  environment.systemPackages = with pkgs; [
      waybar
      dunst
      libnotify
      swww
      rofi-wayland
      alacritty
      vim
      neovim
      wget
      docker
      fastfetch
      git 
      stow
      ly
      tmux
      nixd
      pavucontrol
      brightnessctl
      networkmanagerapplet
  ];

  fonts.packages = with pkgs; [
     (nerdfonts.override { fonts = [ "JetBrainsMono" "FiraCode" "Hack" ]; } )
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      proggyfonts
  ];

  fonts.enableDefaultPackages = true;

# Enable the OpenSSH daemon.
  services.openssh.enable = true;

  system.stateVersion = "24.11"; # DO NOT CHANGE EVER!
}


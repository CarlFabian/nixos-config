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

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	  "steam"
	  "steam-unwrapped"
	  "steam-original"
	  "steam-run"
          "spotify"
	  "bitwig-studio"
  ];
  
  programs.steam.enable = true;
  programs.firefox.enable = true;
  programs.hyprland.enable = true;
  programs.thunar.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ 
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
  ];
  xdg.portal.config = {
	  common = {
		  default = [
			  "hyprland"
			  "gtk"
		  ];
	  };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
      waybar
      dunst
      hypridle
      hyprlock
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
      vesktop
      grim
      swappy
      slurp
      wl-clipboard
      spotify
      qbittorrent
      (pkgs.bitwig-studio.overrideAttrs (oldAttrs: rec {
                         version = "5.0.4";
                         src = pkgs.fetchurl {
                         url = "https://www.bitwig.com/dl/Bitwig%20Studio/${version}/installer_linux/";
                         sha256 = "15hk8mbyda0isbqng00wd0xcp8g91117lkg6f5b2s0xylf858j12";
                         };
                         }))
     guitarix
  ];

 environment.sessionVariables.NIXOS_OZONE_WL = "1";

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


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

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl = {
  enable = true;
  driSupport32Bit = true;

};

hardware.nvidia.open = false;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  networking.hostName = "nixos";
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
    extraConfig.pipewire.adjust-sample-rate = {
	"context.properties" = {
		"default.clock.rate" = 48000;
		"default.clock.quantum" = 128;
		"default.clock.min-quantum" = 128;
		"default.clock.max-quantum" = 128;
	};
    };
  };

services.pipewire.extraConfig.pipewire."92-low-latency" = {
};

security.rtkit.enable = true;

  users.users.oscar = {
	  isNormalUser = true;
	  extraGroups = [ "wheel"
		  "audio"

	  ];
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
	  "steam"
	  "steam-unwrapped"
	  "steam-original"
	  "steam-run"
          "spotify"
          "nvidia-x11"
          "nvidia-settings"
  ];
  
  programs.steam.enable = true;
  programs.firefox.enable = true;
  programs.hyprland.enable = true;

# Thunar stuff
  programs.thunar.enable = true;
  programs.xfconf.enable = true;
  programs.thunar.plugins = with pkgs.xfce; [
	  thunar-archive-plugin
	  thunar-volman
  ];
  services.gvfs.enable = true; # Mount, trash, and other functionalities
  services.tumbler.enable = true; # Thumbnail support for images

  services.flatpak.enable = true;
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

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
	  guitarix
	  helvum
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


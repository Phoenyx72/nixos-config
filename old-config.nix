{ config, lib, pkgs, caelestia-shell, ... }:

{

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  imports = [
    ./hardware-configuration.nix
  ];

nix.gc.automatic = true;
nix.gc.options = "--delete-older-than 5d";

   # Bluetooth
   hardware.bluetooth = {
     enable = true;
     powerOnBoot = true;
   };

  # Boot
  boot = {
  	loader = {
    	grub.enable = false;
		systemd-boot.enable = lib.mkForce false;
		refind.enable = false;
 		efi.canTouchEfiVariables = true;
		efi.efiSysMountPoint = "/boot";
	};

	lanzaboote = {
		enable = true;
		pkiBundle = "/var/lib/sbctl";
	};

    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback \
      video_nr=4,2,3 \
      card_label="WaydroidCam","DroidCam","OBS Virtual Camera" \
      exclusive_caps=0 \
      max_width=1920 \
      max_height=1080
    '';
  };
security.polkit.enable = true;

# udev
services.udev.packages = with pkgs; [ udev ];
services.udev.extraRules = ''
  KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", ATTR{name}=="OBS Virtual Camera", GROUP="video", MODE="0660"
  KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", ATTR{name}=="DroidCam", GROUP="video", MODE="0660"
'';
# Shell
  programs.fish.enable = true;
  users.users.phxo.shell = pkgs.fish;

  programs.appimage.enable = true;

# Windows Drive
  fileSystems."/mnt/windows" = {
    device = "/dev/nvme0n1p3";
    fsType = "ntfs-3g";
    options = [ "defaults" "uid=1000" "gid=100" "umask=022" ];
  };

  # NVIDIA + Graphics
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    enableAllFirmware = true;

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vulkan-loader
        libvdpau
      ];
      extraPackages32 = with pkgs.pkgsi686Linux; [
        vulkan-loader
        libvdpau
      ];
    };

    nvidia = {
      modesetting.enable = true;
      powerManagement.enable = false;
      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
  };

  # Time & Networking
  time.timeZone = "Europe/London";
  networking.networkmanager.enable = true;

  # Display / Desktop
services.xserver.displayManager.sessionCommands = ''
  ${pkgs.xorg.xrandr}/bin/xrandr --output DP-1 --primary --mode 1920x1080 --rate 144 --output HDMI-A-1 --mode 1920x1080 --rate 60 --right-of DP-1
'';

  services = {
    xserver = {
      enable = true;
      autoRepeatDelay = 200;
      autoRepeatInterval = 35;
    };

  	displayManager.sddm = {
    	enable = true;
    	theme = "my-theme";
 	};
    desktopManager.plasma6.enable = true;
	

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    pulseaudio.enable = false;
    dbus.enable = true;
    flatpak.enable = true;
    usbmuxd.enable = true;
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Cosmic
  services.desktopManager.cosmic.enable = true;

 # Rustdesk Background Service
#systemd.user.services.rustdesk = {
#	description = "RustDesk Remote Desktop Service";
#	after = [ "network.target" ];
#	serviceConfig = {
#		ExecStart = "${pkgs.rustdesk}/bin/rustdesk --service";
#		Restart = "always";
#		RestartSec = 5;
#	};
#wantedBy = [ "default.target" ];
#}; 

  # Steam
  programs.steam.enable = true;

  # OBS Studio
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override { cudaSupport = true; };
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  # SSH
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # WayVNC
  systemd.user.services.wayvnc = {
    description = "WayVNC Remote Desktop Server";
    after = [ "graphical-session.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc 0.0.0.0 5900 -C /home/phxo/.config/wayvnc/config";
      Restart = "on-failure";
      Environment = "XDG_RUNTIME_DIR=%t";
    };
    wantedBy = [ "default.target" ];
  };

# Waydroid
  virtualisation.waydroid.enable = true;

# VR driver
services.avahi = {
  enable = true;
  nssmdns4 = true;
  openFirewall = true;

  publish = {
    enable = true;
    userServices = true;
    workstation = true;
  };
};

  # User
  users.users.phxo = {
    isNormalUser = true;
    description = "phxo";
    extraGroups = [ "wheel" "networkmanager" "audio" "plugdev" "video" "docker" ];
    hashedPassword = "$6$BGpMuiWGKziFosz1$7q/C5eiFhsf2smLqclvBFjUyBRqEoS.NonUQpAW4SEHzLCzdfNTAZUUsOIfPs5Bcve9ewCb7JZZ.8P6JNGsSp1";
    packages = with pkgs; [ tree ];
  };

  # Sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Environment Variables
  environment.sessionVariables = {
    EDITOR = "apostrophe";
    VISUAL = "apostrophe";
    BROWSER = "flatpak run app.zen_browser.zen";
    NIXOS_OZONE_WL = "1";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    LIBGL_ALWAYS_INDIRECT = "0";
    XDG_DATA_DIRS = [
      "/var/lib/flatpak/exports/share"
      "$HOME/.local/share/flatpak/exports/share"
      "/usr/local/share"
      "/usr/share"
    ];
  };

  # Docker
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      experimental = true;
      default-address-pools = [
        {
          base = "172.30.0.0/16";
          size = 24;
        }
      ];
    };
  };

  # System Packages
 environment.systemPackages = with pkgs; let
  mySddmTheme = pkgs.stdenv.mkDerivation {
    name = "my-sddm-theme";
    src = ./my-sddm-theme;
    installPhase = ''
      mkdir -p $out/share/sddm/themes/my-theme
      cp -r * $out/share/sddm/themes/my-theme/
    '';
  };

#  myPrism = pkgs.prismlauncher.overrideAttrs (old: {
#  buildInputs = old.buildInputs ++ [ pkgs.ffmpeg ];
# });
 
 myWine = pkgs.wineWowPackages.staging;
in [
  # Utilities
  wget
  git
  fastfetch
  tree
  inotify-tools
  lsof
  trash-cli
  btop
  htop
  jq
  eza
  starship
  apostrophe
  chromium
  vscodium
  wl-clipboard
  gimp
  #rustdesk
  vim

  # Shells & terminal
  fish
  kitty
  foot

  # Graphics / Video
  hyprland
  hyprpicker
  waypaper
  hyprpaper
  swww
  mpv
  vlc
  ffmpeg
  vulkan-tools
  libGL
  libxcb
  v4l-utils
  droidcam
  usbmuxd

  # Steam / Gaming
  steam
  discord
  spotify
  freerdp
  myWine
  winetricks
  appimage-run
   (pkgs.prismlauncher.override {
    additionalPrograms = [ ffmpeg ];
    jdks = [ graalvm-ce zulu8 zulu17 zulu ];
  })
  ryubing

  # Docker / Virtualization
  docker
  docker-compose
  caelestia-shell.packages.x86_64-linux.default

  # File managers / Desktop tools
  nautilus
  kdePackages.filelight
  kdePackages.okular
  gnome-font-viewer
  papirus-icon-theme

  # System / Admin
  efibootmgr
  ntfs3g
  mySddmTheme
  alsa-lib
  atk
  at-spi2-atk
  cups
  gtk3
  nss
  sbctl
];

environment.plasma6.excludePackages = with pkgs.kdePackages; [
  dolphin
];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # Unfree software
  nixpkgs.config.allowUnfree = true;

  # System state version
  system.stateVersion = "25.05";
}

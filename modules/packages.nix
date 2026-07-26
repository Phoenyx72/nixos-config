{ pkgs, caelestia-shell, ... }:

let
  mySddmTheme = pkgs.stdenv.mkDerivation {
    pname = "sddm-theme";
    version = "1.0";

    src = ../sddm-theme;

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/sddm/themes/my-theme
      cp -r ./* $out/share/sddm/themes/my-theme/

      runHook postInstall
    '';
  };

  myWine = pkgs.wineWowPackages.staging;

  myPrismLauncher = pkgs.prismlauncher.override {
    additionalPrograms = [
      pkgs.ffmpeg
    ];

    jdks = with pkgs; [
      graalvm-ce
      zulu8
      zulu17
      zulu
    ];
  };
in
{
  environment.systemPackages = with pkgs; [
    # Command-line utilities
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
    vim
    libimobiledevice
    ifuse
    android-tools
    unzip
    rsync

    # Applications
    apostrophe
    chromium
    vscodium
    gimp

    # Shells and terminals
    fish
    kitty

    # Wayland and desktop tools
    hyprland
    hyprpicker
    waypaper
    hyprpaper
    swww
    wl-clipboard
    nwg-look

    # Media and graphics
    mpv
    vlc
    ffmpeg
    vulkan-tools
    libGL
    libxcb
    v4l-utils
    droidcam
    usbmuxd

    # Gaming and Windows compatibility
    steam
    discord
    spotify
    freerdp
    myWine
    winetricks
    myPrismLauncher
    ryubing

    # Containers and virtualisation
    docker
    docker-compose

    # Caelestia
    caelestia-shell.packages.${pkgs.system}.with-cli

    # File managers and desktop applications
    nautilus
    kdePackages.filelight
    kdePackages.okular
    gnome-font-viewer
    papirus-icon-theme

    # System administration
    efibootmgr
    ntfs3g
    alsa-lib
    atk
    at-spi2-atk
    cups
    gtk3
    nss
    sbctl
    gparted
    polkit_gnome

    # Locally packaged SDDM theme
    mySddmTheme
  ];
}

{ pkgs, inputs, ... }:

environment.systemPackages = with pkgs; [
  # Command-line utilities
  wget
  git
  fastfetch
  tree
  inotify-tools
  lsof
  trash-cli
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
  nodejs
  ttyd

  # Applications
  apostrophe
  chromium
  vscodium
  onlyoffice-desktopeditors

  # Shells and terminals
  fish
  kitty

  # Wayland and desktop tools
  awww
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
  usbmuxd

  # Gaming and Windows compatibility
  steam
  discord
  freerdp
  winePackages.full
  winetricks
  myPrismLauncher
  ryubing

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
  ];
}

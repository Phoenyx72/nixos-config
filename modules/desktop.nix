{ pkgs, inputs, ... }:

{
  services.xserver = {
    enable = true;

    autoRepeatDelay = 200;
    autoRepeatInterval = 35;

    displayManager.setupCommands = ''
      ${pkgs.xset}/bin/xset s off
      ${pkgs.xset}/bin/xset dpms 30 30 30
    '';

  # My Monitors

    displayManager.sessionCommands = ''
      ${pkgs.xrandr}/bin/xrandr \
        --output DP-1 \
        --primary \
        --mode 1920x1080 \
        --rate 144 \
        --output HDMI-A-1 \
        --mode 1920x1080 \
        --rate 60 \
        --right-of DP-1
    '';
  };

  # SDDM Lock ScreenCast
#  services.displayManager.sddm = {
#    enable = true;
#    wayland.enable = false;
#    theme = "my-theme";
#    extraPackages = [
#      pkgs.kdePackages.qt5compat
#    ];
#  };


  # Niri Setup

  programs.niri.enable = true;
  imports = [ inputs.inir.nixosModules.inir ];

  programs.inir.enable = true;


  # Gnome Setup

  services.desktopManager.gnome.enable = true;
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];


  # Hyprland Setup

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # AutoLogin
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "phxo";
    };
    defaultSession = "hyprland";
  };

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

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    config = {
      common = {
        default = [ "gtk" ];
      };

      niri = {
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };

  programs.appimage = {
    enable = true;
    binfmt = true;

    package = pkgs.appimage-run.override {
      extraPkgs = pkgs: with pkgs; [
        icu
      ];
    };
  };

  services.logind.settings.Login = {
    IdleAction = "ignore";
    IdleActionSec = "0";
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    monocraft
  ];
}
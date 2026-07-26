{ pkgs, ... }:

{
  services.xserver = {
    enable = true;

    autoRepeatDelay = 200;
    autoRepeatInterval = 35;

    displayManager.setupCommands = ''
      ${pkgs.xorg.xset}/bin/xset s off
      ${pkgs.xorg.xset}/bin/xset dpms 30 30 30
    '';

    displayManager.sessionCommands = ''
      ${pkgs.xorg.xrandr}/bin/xrandr \
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

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    theme = "my-theme";
    extraPackages = [
      pkgs.kdePackages.qt5compat
    ];
  };

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

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
    ];
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
  ];
}

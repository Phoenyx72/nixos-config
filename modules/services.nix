{ pkgs, ... }:

{
  security.polkit.enable = true;

  services = {
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

    udev = {
      packages = with pkgs; [
        udev
      ];
    };


  programs = {
    appimage.enable = true;
    steam.enable = true;
    localsend.enable = true;
    
    obs-studio = {
      enable = true;
      enableVirtualCamera = true;
      package = pkgs.obs-studio.override {
        cudaSupport = true;
      };
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-backgroundremoval
        obs-vaapi
        obs-gstreamer
        obs-vkcapture
        droidcam-obs
      ];
    };
  };

  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome authentication agent";
    wantedBy = [
      "default.target"
    ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
    };
  };
}

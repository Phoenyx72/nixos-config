{ pkgs, jellyfinPkgs, ... }:

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

      extraRules = ''
        KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", ATTR{name}=="OBS Virtual Camera", GROUP="video", MODE="0660"
        KERNEL=="video[0-9]*", SUBSYSTEM=="video4linux", ATTR{name}=="DroidCam", GROUP="video", MODE="0660"
      '';
    };
  };
  
  services.jellyfin = {
    enable = true;
    package = jellyfinPkgs.jellyfin;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = [ "video" "render" ];

  services.ollama = {
    enable = true;
    acceleration = "cuda";
    host = "0.0.0.0";
  };

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true; # needed for Wayland/KMS capture
    openFirewall = true;
  };
  programs = {
    appimage.enable = true;
    steam.enable = true;

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

  systemd.user.services.wayvnc = {
    description = "WayVNC Remote Desktop Server";

    after = [
      "graphical-session.target"
    ];

    serviceConfig = {
      ExecStart = "${pkgs.wayvnc}/bin/wayvnc 0.0.0.0 5900 -C /home/phxo/.config/wayvnc/config";
      Restart = "on-failure";
      Environment = "XDG_RUNTIME_DIR=%t";
    };

    wantedBy = [
      "default.target"
    ];
  };
}

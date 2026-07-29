{ pkgs, jellyfinPkgs, ... }:

#let
#  ollamaCudaToolkit = pkgs.buildEnv {
#    name = "ollama-cuda-toolkit";
#    paths = with pkgs.cudaPackages; [
      #(pkgs.lib.getLib cuda_cudart)
      #(pkgs.lib.getLib libcublas)
      #(pkgs.lib.getLib cccl)
      #(pkgs.lib.getOutput "static" cuda_cudart)
      #(pkgs.lib.getBin cuda_nvcc)
#      cuda_nvcc
#      cuda_cudart
#      libcublas
#      cccl
#    ];
#    ignoreCollisions = true;
#  };

#  ollamaCuda = pkgs.ollama-cuda.overrideAttrs (old: {
#    env = (old.env or { }) // {
#      CUDA_PATH = ollamaCudaToolkit;
#      CUDAToolkit_ROOT = ollamaCudaToolkit;
##    };
#  });
#in
{
  security.polkit.enable = true;

  services.code-server = {
    enable = true;
    user = "phxo";
    host = "0.0.0.0";
    port = 8081;
  };

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
    package = pkgs.ollama;
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

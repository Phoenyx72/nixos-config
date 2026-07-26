{ config, lib, ... }:

{
  boot = {
    loader = {
      grub.enable = false;

      systemd-boot.enable = lib.mkForce false;

      refind.enable = false;

      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot";
      };
    };

    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };

    kernelModules = [
      "v4l2loopback"
    ];

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    extraModprobeConfig = ''
      options v4l2loopback \
        video_nr=1 \
        card_label="OBS Virtual Camera" \
        exclusive_caps=0 \
        max_width=1920 \
        max_height=1080
    '';
  };
}

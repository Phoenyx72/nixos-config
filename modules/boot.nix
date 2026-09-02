{ config, lib, ... }:

{
  boot = {
    loader = {
      systemd-boot.enable = true;

      efi = {
        canTouchEfiVariables = false;
      };
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

{ config, pkgs, ... }:

{
  boot.kernelModules = [ "uinput" ];
  hardware = {
    enableAllFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };

    opentabletdriver.enable = true;
    uinput.enable = true;
    nvidia-container-toolkit.enable = true;

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


}

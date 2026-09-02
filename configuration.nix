{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./apple-silicon-support
    ./modules
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 5d";
  };

  hardware.asahi.enable = true;

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/London";

  system.stateVersion = "25.05";
}

{ ... }:

{
  imports = [
    ./hardware-configuration.nix
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

  nixpkgs.config.allowUnfree = true;

  time.timeZone = "Europe/London";

  system.stateVersion = "25.05";
}
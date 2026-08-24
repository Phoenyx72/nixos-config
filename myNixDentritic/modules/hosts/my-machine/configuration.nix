{ self, inputs, ... }: {

  flake.nixoxModules.myMachineConfig = { pkgs, lib, ... }: {
    
    imports = [
      self.nixosModules.myMachineHardware
     ];

    environment.systemPackages = with pkgs; [
      firefox
      vim
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

  };
  
}
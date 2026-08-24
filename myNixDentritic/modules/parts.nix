{ inputs, ... }:

{
  flake.nixosModules.myMachineHardware =
    inputs.nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        ./myMachineHardware.nix
      ];
    };
}
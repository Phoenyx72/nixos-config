{
  description = "NixOS configuration with Caelestia Shell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-jellyfin.url = "github:nixos/nixpkgs/nixos-unstable";

    caelestia-shell = {
      url = "github:caelestia-dots/shell";
    };
    lanzaboote = {
      # Track upstream while nixpkgs has removed the boot.bootspec.enable option.
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = 
    { 
		self, 
		nixpkgs,
		nixpkgs-jellyfin,
		caelestia-shell, 
		lanzaboote,
		... 
	}:
  {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit caelestia-shell;
        jellyfinPkgs = import nixpkgs-jellyfin {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };

      modules = [
        ./configuration.nix
		lanzaboote.nixosModules.lanzaboote
        #({ pkgs, caelestia-shell, ... }: {
        #  environment.systemPackages = [
        #    caelestia-shell.packages.${pkgs.system}.default
        #  ];
        #})
      ];
    };
  };
}

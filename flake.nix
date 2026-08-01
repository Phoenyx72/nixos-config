{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-jellyfin.url = "github:nixos/nixpkgs/nixos-unstable";

    lanzaboote = {
      # Track upstream while nixpkgs has removed the boot.bootspec.enable option.
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{
    self,
    nixpkgs,
    nixpkgs-jellyfin,
    lanzaboote,
    qylock,
    ...
  }: let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    glfw-waywall = pkgs.callPackage ./pkgs/glfw-waywall.nix {};
  in
  {
    packages.${system}.glfw-waywall = glfw-waywall;

    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      specialArgs = {
        inherit inputs;

        jellyfinPkgs = import nixpkgs-jellyfin {
          system = "x86_64-linux";
          config.allowUnfree = true;
        };
      };

      modules = [
        ./configuration.nix
        lanzaboote.nixosModules.lanzaboote

        qylock.nixosModules.default
        ({ pkgs, ... }: {
          services.displayManager.sddm.enable = true;
          services.displayManager.sddm.wayland.enable = true;

          programs.qylock = {
            enable = true;
            theme = "girl-coffee";          # any directory name under themes/
            # sddm.enable = true;             # installs theme + sets it active (default)
            # quickshell.enable = true;       # adds `qylock-lock` to PATH (default)

            # Optional per-theme tweaks (replaces the interactive prompts):
            themeOptions = {
              terraria.backgroundMode = "time";              # time | random | static
              Genshin.backgroundMode = "time";
              clockwork.orbital = { themeMode = "dark"; enableWindup = true; };
              osu.gameMode = "menu";                         # menu | game
            };
          };
        })
      ];
    };
  };
}
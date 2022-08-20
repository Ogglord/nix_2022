{
  description = "Ogglord NixOs flakes";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hardware.url = "github:nixos/nixos-hardware";

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # Extras
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nixos-hardware.inputs.nixpkgs.follows = "nixpkgs";
    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";

    #neovim-flake.url = "github:traxys/nvim-flake";
    #neovim-flake.inputs.nixpkgs.follows = "nixpkgs";
    nvim-traxys = {
      url = "github:traxys/nvim-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-hardware, nvim-traxys, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs systems;
      systems = [
#        "aarch64-linux"
#        "i686-linux"
        "x86_64-linux"
#        "aarch64-darwin"[]
#        "x86_64-darwin"
      ];
    in rec {
      # Your custom packages and modifications
      overlays = { default = import ./overlay { inherit inputs; }; };

      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system: {
        default = legacyPackages.${system}.callPackage ./shell.nix { };
      });

      # Reexport nixpkgs with our overlays applied
      # Acessible on our configurations, and through nix build, shell, run, etc.
      legacyPackages = forAllSystems (system:
        import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues overlays;
        });

      nixosConfigurations = {
        # hostname
        codebook = nixpkgs.lib.nixosSystem {
          pkgs = legacyPackages.x86_64-linux;
          specialArgs = { inherit inputs; }; # Pass flake inputs to our config
          modules = (builtins.attrValues nixosModules) ++ [
            # > Our main nixos configuration file <
            ./nixos/configuration.nix
            nixos-hardware.nixosModules.lenovo-thinkpad-t470s
          ];
        };
      };

      homeConfigurations = {
        # username@hostname
        "oscar@codebook" =
          home-manager.lib.homeManagerConfiguration {
            pkgs = legacyPackages.x86_64-linux;
            extraSpecialArgs = { inherit inputs nvim-traxys; }; # Pass flake inputs to our config
            modules = (builtins.attrValues homeManagerModules) ++ [
              # > Our main home-manager configuration file <
               ({pkgs, ...}: {
                nixpkgs.overlays = [
                  inputs.nvim-traxys.overlay.x86_64-linux
                ];
                nixpkgs.config.allowUnfree = true;
             })
             
              ./home-manager/home.nix
            ];
          };
      };
    };
}

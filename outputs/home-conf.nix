{ system, nixpkgs, nurpkgs, home-manager, neovim-flake, ... }:

let
  username = "oscar";
  homeDirectory = "/home/${username}";
  configHome = "${homeDirectory}/.config";

  pkgs = import nixpkgs {
    inherit system;

    config.allowUnfree = true;
    config.xdg.configHome = configHome;

    overlays = [
      nurpkgs.overlay
      neovim-flake.overlays.default
      (import ../home/overlays/ranger)
    ];
  };

  nur = import nurpkgs {
    inherit pkgs;
    nurpkgs = pkgs;
  };

  mkHome = { hidpi ? false }: (
    home-manager.lib.homeManagerConfiguration rec {
      inherit pkgs;

      extraSpecialArgs = {
        inherit hidpi;
        addons = nur.repos.rycee.firefox-addons;
      };

      modules = [
        {
          imports = [
            neovim-flake.nixosModules.hm
            ../home/home.nix
           ];
          home = {
            inherit username homeDirectory;
            stateVersion = "22.11";
          };
        }
      ];
    });
in
{
  oscar = mkHome { hidpi = false; };
  oscar-dell = mkHome { hidpi = false; };
}

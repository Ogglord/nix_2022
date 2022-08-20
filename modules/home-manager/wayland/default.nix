# See available options at https://nix-community.github.io/home-manager/options.html
{ config, lib, pkgs, ... }:
  let
    inherit (lib) mkMerge mkIf;
    waylandEnabled = true;
  in {
    imports = [
    #  ./git.nix
    #  ./gpg.nix
      ./wayland.nix
      ./wofi.nix
    ];
    home.packages = with pkgs; [
      # calibre # error with python3.9-apsw-3.37.0-r1.drv 2022-04-09
      wl-clipboard
      grim
      slurp
      wayland
      firefox-wayland
      openzone-cursors
      ubuntu-themes
      #virt-manager
    ];
    home.sessionVariables = mkMerge [
      {
        EDITOR = "vim";
      }
      (mkIf waylandEnabled {
        MOZ_ENABLE_WAYLAND = 1;
        XDG_CURRENT_DESKTOP = "sway";
      })
    ];

    programs = {
      alacritty = {
        enable = true;
        settings = {
          font = rec {
            normal.family = "FiraCode";
            size = 11;
            bold = { style = "Bold"; };
          };
          #env.TERM = "xterm-color";
       
        };
      };
      foot = {
        enable = true;
        settings = {
          main = {
            term = "xterm-256color";

            font = "FiraCode:size=12";
            dpi-aware = "yes";
          };
          bell = {
            urgent = true;
            notify = true;
          };
          mouse = {
            hide-when-typing = "yes";
          };
        };
      };
     # zsh.enable = true;
    };
 }

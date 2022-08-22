{ config, lib, pkgs, specialArgs, ... }:

let
  fontSize = if specialArgs.hidpi then 10 else 8;
in
{
  programs.vscode = {
    enable = true;
    userSettings = {
            "window.zoomLevel" = -3;
            "terminal.integrated.fontFamily" = "JetBrainsMono";
            "workbench.startupEditor" = "none";
            "git.autofetch" = true;
    };
    package = pkgs.vscode;
    extensions = with pkgs.vscode-extensions; [
            bbenoist.nix
            justusadam.language-haskell
    ];
    
  };
}


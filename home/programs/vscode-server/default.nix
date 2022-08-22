{ pkgs, lib, specialArgs, ... }:

{
  imports = [
    "${fetchTarball { url = "https://github.com/msteen/nixos-vscode-server/tarball/master"; sha256 = "1dr3v3mlf61nrs3f3d9qx74y8v5jihkk8wd1li4sglx22aqh4xf6"; } }/modules/vscode-server/home.nix"
  ];

  services.vscode-server.enable = true;
}

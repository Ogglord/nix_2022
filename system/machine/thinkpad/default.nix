{ config, pkgs, hardware, ... }:
let
   nixos-hardware = hardware;
in
{
  imports =  [
    # Hardware scan
    nixos-hardware.nixosModules.lenovo-thinkpad-t470s
    ./hardware-configuration.nix
  ];

  # Use the EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking = {
    hostName = "thinkpad";
    interfaces.wlp58s0.useDHCP = true;
  };

  # services.xserver = {
  #   xrandrHeads = [
  #     { output = "eDP-1";
  #       primary = true;
  #       monitorConfig = ''
  #         Option "PreferredMode" "1920x1080"
  #         Option "Position" "0 0"
  #       '';
  #     }
  #   ];
  #   resolutions = [
  #     { x = 1920; y = 1080; }
  #   ];
  # };
}

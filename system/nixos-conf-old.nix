{ inputs, lib, config, pkgs, ... }: {

  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware), use something like:
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # It's strongly recommended you take a look at
    # https://github.com/nixos/nixos-hardware
    # and import modules relevant to your hardware.

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix

    # You can also split up your configuration and import pieces of it here.
  ];

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  ##collect garbage
  nix.gc.automatic = true;
  nix.gc.options = "--delete-older-than 2d";  

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };


  # Remove if you wish to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true;
  networking.hostName = "codebook";

    # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.consoleMode = "max";
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.
  users.users = {
    oscar = {
      # TODO: You can set an initial password for your user.
      # If you do, you can skip setting a root password by passing '--no-root-passwd' to nixos-install.
      # Be sure to change it (using passwd) after rebooting!
      # initialPassword = "correcthorsebatterystaple";
      isNormalUser = true;
      shell = pkgs.zsh;
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCzgCnZ9zB+PFpuFHdNPlpV3xIM3Ong9Z6ZYy6ygi7OTsPmtrNx4VsM1gUN64JrCTjx4dySi5+9VxQjQnujfF9OgcAfic8sOlfHJQuzOfXVWRVXRgponfbqeeQ2f6JNvgZAFcf2XtFEXqV7tR8Tm3uHCYGYlqtVthcG4wNwXMteHKt5a3a9knxtYcDU21GfmJhCvE5W0meUTPuP7RhaIaaR9WKQ1RG7xa1Y41NCwEQbJol/5FdEDtMhhc20cMJuvz9d50JqlsMtoHCB0ZcRlnvVWx2kxtYb/Bw6KW11FsOaMEXZrveDeUFnoE7W6Os7ccHyV6ZgxIX6/zGFA1P+oXQcyJcWwoIZG+ZfWwr4ZNhM8cCHmHMIfEEeYSkmxh2Bv2wlvJq3IM7nRGenhJ42pZb279C3vynUQhJZjnOoK7hz7POl6b9b48iCDVgNwOVdIZhdo9OS61bB2i3+ue4qlBP8UPig/ihZ6Jf1rHvr0j3JzqxsKJLTDj6zmxRg83iMdKU= insurely@ogglord.com"
      ];
      # TODO: Be sure to add any other groups you need (such as networkmanager, audio, docker, etc)
      extraGroups = [ "wheel" "networkmanager" "audio" ];
    };
  };

  environment.systemPackages = with pkgs; [
    git
    wget
  ];

   xdg = {
      portal = {
        enable = true;
        # extraPortals = with pkgs; [
        #     xdg-desktop-portal-gtk
        # ];
        # gtkUsePortal = true;
        wlr = {
            enable = true;
        };
      };
    };
    programs.dconf.enable = true; 


  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "22.11";
}

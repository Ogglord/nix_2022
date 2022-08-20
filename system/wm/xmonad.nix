{ config, lib, pkgs, ... }:

{
  programs.dconf.enable = true;

  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };

    xserver = {
      enable = true;
      autorun = true; ## added 20 aug 2022 /Ogg

      # extraLayouts.us-custom = {
      #   description = "US layout with custom hyper keys";
      #   languages   = [ "eng" ];
      #   symbolsFile = ./us-custom.xkb;
      # };

      layout = "se";

      libinput = {
        enable = true;
        touchpad.disableWhileTyping = true;
      };

      serverLayoutSection = ''
        Option "StandbyTime" "0"
        Option "SuspendTime" "0"
        Option "OffTime"     "0"
      '';

      displayManager = {
        defaultSession = "none+xmonad";
        lightdm.enable = false; ## added 20 aug 2022 /Ogg
        startx.enable = true;   ## added 20 aug 2022 /Ogg

      };

      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
      };

      # does not work, setting it manually on start up
      xkbOptions = "ctrl:nocaps";

    };
  };

  hardware.bluetooth = {
    enable = true;
    hsphfpd.enable = true;
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
      };
   };
  };

  services.blueman.enable = true;

  systemd.services.upower.enable = true;
}

{ pkgs, ... }: {
  imports = [
    ./xresources.nix
#    ./light.nix
    ./dark.nix
  ];
  #home-manager.users.oscar.dconf.enable = true;
  gtk = {
   # theme.package = "${pkgs.whitesur-gtk-theme}";
   # theme.name = "WhiteSur-gtk-theme-light";
    enable = true;
    font = {
      package = null;
      name = "FiraCode";
    };
    gtk2.extraConfig = ''
      gtk-key-theme-name = "Materia-dark-compact"
    '';
    gtk3.extraConfig = { gtk-key-theme-name = "Materia-dark-compact"; };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.pointerCursor = {
    x11.enable = true;
    gtk.enable = true;
    package = pkgs.capitaine-cursors;
    name = "capitaine-cursors-white";
    size = 16;
  };

  home.packages = with pkgs; [
 #   WhiteSur-gtk-theme
  #  dracula-theme
    gnome.gnome-themes-extra
    gsettings-desktop-schemas
    #gnome3.gnome-desktop
    #gnome3.gnome-settings-daemon
   # dconf
    libsForQt5.qtstyleplugins
  ];

  dconf.settings = {
    "org/gnome/calculator" = {
      button-mode = "programming";
      show-thousands = true;
      base = 10;
      word-size = 64;
      #window-position = lib.hm.gvariant.mkTuple [100 100];
    };
  };
}
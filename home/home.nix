{ config, lib, pkgs, stdenv, ... }:

let
  # workaround to open a URL in a new tab in the specific firefox profile
  work-browser = pkgs.callPackage ./programs/browsers/work.nix {};

  defaultPkgs = with pkgs; [
    any-nix-shell        # fish support for nix shell
    arandr               # simple GUI for xrandr
    bottom               # alternative to htop & ytop
   # calibre              # e-book reader
    dconf2nix            # dconf (gnome) files to nix converter
    dmenu                # application launcher
    docker-compose       # docker manager
    #dive                 # explore docker layers
    #drawio               # diagram design
    duf                  # disk usage/free utility
    exa                  # a better `ls`
    fd                   # "find" for files
    #gimp                 # gnu image manipulation program
    #glow                 # terminal markdown viewer
    #gnomecast            # chromecast local files
    #hyperfine            # command-line benchmarking tool
    #insomnia             # rest client with graphql support
    #jitsi-meet-electron  # open source video calls and chat
    #jmtpfs               # mount mtp devices
    killall              # kill processes by name
    #libreoffice          # office suite
    libnotify            # notify-send command
    multilockscreen      # fast lockscreen based on i3lock
    ncdu                 # disk space info (a better du)
    neofetch             # command-line system information
    #ngrok                # secure tunneling to localhost
    nix-index            # locate packages containing certain nixpkgs
    nyancat              # the famous rainbow cat!
    #md-toc               # generate ToC in markdown files
    pavucontrol          # pulseaudio volume control
    paprefs              # pulseaudio preferences
    pasystray            # pulseaudio systray
    #pgcli               # modern postgres client (FIXME: broken on nixpkgs)
    playerctl            # music player controller
    prettyping           # a nicer ping
    #protonvpn-gui        # official proton vpn client
    pulsemixer           # pulseaudio mixer
    ranger               # terminal file explorer
    #ripgrep              # fast grep
    rnix-lsp             # nix lsp server
    #simple-scan          # scanner gui
    simplescreenrecorder # screen recorder gui
    #skypeforlinux        # messaging client
    #slack                # messaging client
    #tdesktop             # telegram messaging client
    #tex2nix              # texlive expressions for documents
    #tldr                 # summary of a man page
    #tree                 # display files in a tree view
    #vlc                  # media player
    xsel                 # clipboard support (also for neovim)
    yad                  # yet another dialog - fork of zenity

    # work stuff
    work-browser

    # fixes the `ar` error required by cabal
    binutils-unwrapped
  ];

  gitPkgs = with pkgs.gitAndTools; [
    diff-so-fancy # git diff with colors
    #git-crypt     # git files encryption
    hub           # github command-line client
    tig           # diff and commit view
  ];

  gnomePkgs = with pkgs.gnome3; [
    eog            # image viewer
    evince         # pdf reader
    nautilus       # file manager
  ];

  polybarPkgs = with pkgs; [
    font-awesome          # awesome fonts
    material-design-icons # fonts with glyphs
    xfce.orage            # lightweight calendar
  ];

  scripts = pkgs.callPackage ./scripts/default.nix { inherit config pkgs; };

  xmonadPkgs = with pkgs; [
    networkmanager_dmenu   # networkmanager on dmenu
    networkmanagerapplet   # networkmanager applet
    nitrogen               # wallpaper manager
    xcape                  # keymaps modifier
    xorg.xkbcomp           # keymaps modifier
    xorg.xmodmap           # keymaps modifier
    xorg.xrandr            # display manager (X Resize and Rotate protocol)
  ];

in
{
  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    (import ./overlays/beauty-line)
    (import ./overlays/coc-nvim)
  ];

  imports = (import ./modules) ++ (import ./programs) ++ (import ./services) ++ [(import ./themes)];

  xdg.enable = true;

  home.keyboard = null;

  home = {
    packages = defaultPkgs ++ gitPkgs ++ gnomePkgs ++ polybarPkgs ++ scripts ++ xmonadPkgs;

    sessionVariables = {
      DISPLAY = ":0";
      EDITOR = "nvim";
    };
  };

  # restart services on change
  systemd.user.startServices = "sd-switch";

  # notifications about home-manager news
  news.display = "silent";

  programs = {
    # bat is cat with wings! try it
    bat.enable = true;

    broot = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type file --follow"; # FZF_DEFAULT_COMMAND
      defaultOptions = [ "--height 20%" ]; # FZF_DEFAULT_OPTS
      fileWidgetCommand = "fd --type file --follow"; # FZF_CTRL_T_COMMAND
    };

    #gpg.enable = true;

    htop = {
      enable = true;
      settings = {
        sort_direction = true;
        sort_key = "PERCENT_CPU";
      };
    };

    jq.enable = true;

    ssh.enable = true;

    ## smarter cd use "z" instead of "cd" - space+tab to toggle multiple match
    zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [];
    };

    # programs with custom modules
    #megasync.enable = true;
    spotify.enable = true;
  };

  services = {
    flameshot.enable = true;
  };

}

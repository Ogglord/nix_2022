# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)

{ inputs, lib, config, pkgs, nvim-traxys, ... }: {
  imports = [
    # If you want to use home-manager modules from other flakes (such as nix-colors), use something like:
    # inputs.nix-colors.homeManagerModule
    # TODO .x86_64-linux to "${system}"
    inputs.nvim-traxys.home-managerModule.x86_64-linux
    "${fetchTarball { url = "https://github.com/msteen/nixos-vscode-server/tarball/master"; sha256 = "1dr3v3mlf61nrs3f3d9qx74y8v5jihkk8wd1li4sglx22aqh4xf6"; } }/modules/vscode-server/home.nix"
    
    # Feel free to split up your configuration and import pieces of it here.
    ./theme
  ];
  
  
  # Comment out if you wish to disable unfree packages for your system
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (pkg: true); #workaround

  home = {
    username = "oscar";
    homeDirectory = "/home/oscar";
  };

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [ htop fira-code fira-code-symbols ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git = {
    enable = true;      
    # Additional options for the git program
    package = pkgs.gitAndTools.gitFull; # Install git wiith all the optional extras
    userName = "Ogglord";
    userEmail = "oggelito@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      # Use vim as our default git editor
      core.editor = "vim";
      # Cache git credentials for 15 minutes
      credential.helper = "cache";
    };
  };
  
  programs.zsh = {
    enable  = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtra = ''
      #bindkey "''${key[Up]}" up-line-or-search
    '';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    plugins = [
    {
      # will source zsh-autosuggestions.plugin.zsh
      name = "zsh-autosuggestions";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-autosuggestions";
        rev = "v0.7.0";
        sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
      };
    }
    {
      name = "enhancd";
      file = "init.sh";
      src = pkgs.fetchFromGitHub {
        owner = "b4b4r07";
        repo = "enhancd";
        rev = "v2.2.4";
        sha256 = "9/JGJgfAjXLIioCo3gtzCXJdcmECy6s59Oj0uVOfuuo=";
      };
    }
    ];  
  }; # end of zsh

  

 
  services.vscode-server.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.11";
}

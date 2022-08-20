{ config, pkgs, lib, ... }:

let
 autosuggestions =  {
      # will source zsh-autosuggestions.plugin.zsh
      name = "zsh-autosuggestions";
      src = pkgs.fetchFromGitHub {
        owner = "zsh-users";
        repo = "zsh-autosuggestions";
        rev = "v0.7.0";
        sha256 = "KLUYpUu4DHRumQZ3w59m9aTW6TBKMCXl2UcKi4uMd7w=";
      };
    };

  enhancd =  {
      name = "enhancd";
      file = "init.sh";
      src = pkgs.fetchFromGitHub {
        owner = "b4b4r07";
        repo = "enhancd";
        rev = "v2.2.4";
        sha256 = "9/JGJgfAjXLIioCo3gtzCXJdcmECy6s59Oj0uVOfuuo=";
      };
    };

  fzfConfig = ''
    # Extra config from Ogglord
    set -x FZF_DEFAULT_OPTS "--preview='bat {} --color=always'" \n
    set -x SKIM_DEFAULT_COMMAND "rg --files || fd || find ."
  '';

 
  zshConfig = ''
    #bind \t accept-autosuggestion
    #set fish_greeting
    '' + fzfConfig;
in
{
  programs.zsh = {
    enable  = true;
    autocd = true;
    enableCompletion = true;
    enableAutosuggestions = true;

    # is this neeeded?
    #initExtra = ''
    #  #bindkey "''${key[Up]}" up-line-or-search
    #'';
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };
    plugins = [
      #  autosuggestions
      #  enhancd
    ];  
    shellAliases = {
      cat  = "bat";
      dc   = "docker-compose";
      dps  = "docker-compose ps";
      dcd  = "docker-compose down --remove-orphans";
      drm  = "docker images -a -q | xargs docker rmi -f";
      du   = "ncdu --color dark -rr -x";
      ls   = "exa";
      ll   = "ls -a";
      ".." = "cd ..";
      ping = "prettyping";
      tree = "exa -T";
    };

    #initExtra = zshConfig;
  }; 

  

  #xdg.configFile."fish/completions/keytool.fish".text = custom.completions.keytool;
  #xdg.configFile."fish/functions/fish_prompt.fish".text = custom.prompt;
}

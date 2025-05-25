{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;
  
  programs = {
    bash.enable = true;
    git = {
      enable = true;
      userName = "Maciej Lewkowicz";
      userEmail = "c0d33p@zyztem";
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
      };
    };
  };
  
  # Default programs
  home.packages = with pkgs; [
    remnote
    vesktop
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  xdg.configFile."mimeapps.list" = lib.mkIf config.xdg.mimeApps.enable { force = true; };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/remnote" = "remnote.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";
    };
  };

}


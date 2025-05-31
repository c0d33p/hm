{ config, pkgs, lib, ... }:

{
  
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
    qalculate-qt
  ];

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      hardtime-nvim
    ];
    
    extraLuaConfig = ''
      -- Line numbers configuration
      vim.opt.relativenumber = true
      vim.opt.number = true
    
      -- Hardtime configuration
      require("hardtime").setup({
        max_time = 1000,
        max_count = 4,
        disable_mouse = true,
        hint = true,
        notification = true,
        allow_different_key = false,
      })
    '';
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


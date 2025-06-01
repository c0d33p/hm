{ config, pkgs, lib, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    
    plugins = with pkgs.vimPlugins; [
      plenary-nvim
      hardtime-nvim
      nui-nvim
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
	showmode = false,
        hint = true,
        notification = true,
        allow_different_key = false,
      })
    '';
  };
}

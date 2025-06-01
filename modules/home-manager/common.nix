{ config, pkgs, lib, ... }:

{
  programs = {
    bash.enable = true;

    zoxide = {
      enable = true;
      enableBashIntegration= true;
      };

    atuin = {
      enable = true;
      settings = {
        search_mode = "fuzzy";
	};
    };

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
    zoxide
    remnote
    vesktop
    qalculate-qt
  ];

  xdg.configFile."mimeapps.list" = lib.mkIf config.xdg.mimeApps.enable { force = true; };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "x-scheme-handler/remnote" = "remnote.desktop";
      "x-scheme-handler/discord" = "vesktop.desktop";
    };
  };
}


{ config, lib, pkgs, nix-flatpak, ... }:

{
  imports = [
    ../../modules/home-manager/common.nix
    ../../modules/home-manager/terminals
    ../../modules/home-manager/editors
    ../../modules/home-manager/programming

    ../../modules/home-manager/flatpak.nix # Like configure plugin
    nix-flatpak.homeManagerModules.nix-flatpak # Like install plugin
  ];

  # Home Manager needs a bit of information about you and the paths it should manage
  home = {
    username = "c0d33p";
    homeDirectory = lib.mkForce "/home/c0d33p";
    stateVersion = "25.05";
  };

  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  # Packages to install
  home.packages = with pkgs; [
    firefox
  ];

  # Program-specific configurations
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
    shellAliases = {
      ll = "ls -l";
      lt = "lsd --tree";
      update = "sudo nixos-rebuild switch";
    };
  };
}


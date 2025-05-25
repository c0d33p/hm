{ config, lib, pkgs, nix-flatpak, ... }:

{
  imports = [
    ../../modules/home-manager/common.nix

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
    htop
  ];

  # Program-specific configurations
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      eval "$(direnv hook bash)"
    '';
    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };
  };
}


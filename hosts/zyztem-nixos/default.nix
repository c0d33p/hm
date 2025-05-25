{ config, pkgs, pkgs-unstable, lib, ... }:

{
  imports = [
    ./hardware.nix
    ./software.nix
    ./disko.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/hardware/nvidia.nix
    ../../modules/nixos/hardware/audio.nix

    ## TODO replace kde
    #../../modules/nixos/desktop/xfce.nix
    #../../modules/nixos/desktop/hyperland.nix
    ../../modules/nixos/desktop/steam.nix
  ];

  ## TODO Move c0d33p configuration to user module to import it between nixos hosts
  users.users.c0d33p = {
    isNormalUser = true;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  };

  security.sudo.extraRules = [
    { users = [ "c0d33p" ];
      commands = [
        { command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  services.displayManager = {
    defaultSession = "plasmax11";
    sddm.enable = true;
    autoLogin = {
      enable = true;
      user = "c0d33p";
    };
  };
  services.desktopManager.plasma6.enable = true;
  services.flatpak.enable = true;

  programs.direnv.enable = true;
  programs.direnv.enableBashIntegration = true;
  services.lorri.enable = true;

  networking.hostName = "zyztem-nixos";
  system.stateVersion = "25.05";
}

{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true; # use xkb.options in tty.
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ]; 

  # Enable flatpak system wide
  services.flatpak.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # Basic system packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    screen
    tmux
    curl
    git
    croc
  ];
}

{ pkgs, lib, ... }:

{
  # Część systemowa - konfiguracja Steam.
  programs.steam = lib.mkIf pkgs.stdenv.isNixOS {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Część użytkownika - dodatkowe oprogramowanie.
  home.packages = with pkgs; [
    lutris
    winetricks
    protonup-qt
  ];
}

{ config, pkgs, lib, ... }:

{
  # --- Część systemowa (aktywna tylko na NixOS) ---
  services.flatpak.enable = lib.mkIf pkgs.stdenv.isNixOS true;
  xdg.portal = lib.mkIf pkgs.stdenv.isNixOS {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # --- Część użytkownika (aktywna w Home Manager) ---
  services.flatpak = {
    packages = [
    "net.waterfox.waterfox"
    "org.videolan.VLC"
    "com.spotify.Client"
    "org.libreoffice.LibreOffice"
  ];

  uninstallUnmanaged = true;
  update.onActivation = false;
  };
}

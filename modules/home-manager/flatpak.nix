{ config, pkgs, lib, ... }:

{
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
  
  xdg.configFile."mimeapps.list" = lib.mkIf config.xdg.mimeApps.enable { force = true; };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html"                = "net.waterfox.waterfox";
      "x-scheme-handler/http"    = "net.waterfox.waterfox";
      "x-scheme-handler/https"   = "net.waterfox.waterfox";
      "x-scheme-handler/about"   = "net.waterfox.waterfox";
      "x-scheme-handler/unknown" = "net.waterfox.waterfox";
    };
  };
}

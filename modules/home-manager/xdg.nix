{ config, lib, ... }:

{
  xdg.mimeApps = {
    enable = true;
    # Używamy `lib.mkMerge`, aby bezpiecznie połączyć wiele definicji w jedną.
    defaultApplications = lib.mkMerge [
      # Skojarzenia z profilu "desktop-apps"
      (lib.mkIf (lib.elem "desktop-apps" config.profiles) {
        "x-scheme-handler/remnote" = "remnote.desktop";
        "x-scheme-handler/discord" = "vesktop.desktop";
      })

      # Skojarzenia z profilu "flatpak"
      (lib.mkIf (lib.elem "flatpak" config.profiles) {
        "text/html"                = "firefox.desktop";
        "x-scheme-handler/http"    = "firefox.desktop";
        "x-scheme-handler/https"   = "firefox.desktop";
        "x-scheme-handler/about"   = "firefox.desktop";
        "x-scheme-handler/unknown" = "firefox.desktop";
      })

      # W przyszłości możesz tu dodawać kolejne bloki dla innych profili...
      # (lib.mkIf (lib.elem "office" config.profiles) { ... })
    ];
  };
}

{ pkgs, ... }:

{
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions = with pkgs.firefox-addons; [
        istilldontcareaboutcookies
      ];

      # Przykładowe ustawienia `about:config`
      settings = {
        "privacy.resistFingerprinting" = true;
        "privacy.trackingprotection.enabled" = true;
        "gfx.webrender.all" = true;
      };
    };
  };
}

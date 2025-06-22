{ ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_GB.UTF-8"; # Używam wartości z Twojego pliku

  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}

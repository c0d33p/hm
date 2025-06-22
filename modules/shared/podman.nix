{ pkgs, lib, ... }:
{
  # Część systemowa dla profilu "podman"
  virtualization.podman = lib.mkIf pkgs.stdenv.isNixOS {
    enable = true;
    # Włączenie gniazda kompatybilnego z Dockerem dla lepszej integracji.
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };

  # Część użytkownika dla profilu "podman"
  home.packages = with pkgs; [
    podman-compose
    lazydocker
  ];
}

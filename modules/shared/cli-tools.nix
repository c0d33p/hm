{ config, pkgs, lib, ... }:

let
  # Definiujemy listę pakietów w jednym, centralnym miejscu
  cliPackages = with pkgs; [
    htop
    tree
    fd
    ripgrep
    lsd
    du-dust
    croc
    wget
    tmux
    screen
  ];
in
{
  # Na systemach NixOS instalujemy pakiety globalnie
  environment.systemPackages = lib.mkIf pkgs.stdenv.isNixOS cliPackages;

  # Na systemach non-NixOS (np. Home Manager na Ubuntu/macOS)
  # instalujemy je w profilu domowym użytkownika.
  home.packages = lib.mkIf (!pkgs.stdenv.isNixOS) cliPackages;
}

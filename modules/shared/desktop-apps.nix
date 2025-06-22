{ pkgs, pkgs-unstable, ... }:

{
  # Wszystkie te aplikacje są instalowane w środowisku użytkownika.
  home.packages = with pkgs; [
    remnote
    vesktop
    qalculate-qt
  ] ++ (with pkgs-unstable; [
    logseq
    anki-bin
  ]);
}

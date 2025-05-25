{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    htop
    tree
    fd
    ripgrep
    lsd
    du-dust
  ];
}

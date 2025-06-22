{ ... }:
{
  imports = [
    ./disko.nix
    ./hardware.nix
    ../../modules/nixos/hardware/audio.nix
    ../../modules/nixos/hardware/nvidia.nix
  ];
  networking.hostName = "zyztem-nixos";
}

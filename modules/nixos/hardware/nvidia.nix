{ config, pkgs, lib, ... }:

{
  # Pozwól na unfree (NVIDIA drivers)
  nixpkgs.config.allowUnfree = true;

  hardware.graphics = {
    enable = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
    xkb.layout = "pl, de";
    xkb.options = "grp:win_space_toggle";
  };
  
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
}

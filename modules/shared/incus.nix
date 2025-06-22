{ config, pkgs, pkgs-unstable, lib, ... }:
let
  # Pobieramy listę nazw użytkowników zdefiniowanych w systemie NixOS.
  userNames = if pkgs.stdenv.isNixOS then
                builtins.map (user: user.name) (lib.attrValues config.users.users)
              else
                [ config._module.args.username ]; # Na non-NixOS, tylko bieżący użytkownik.
in
{
  # Część systemowa dla profilu "incus"
  virtualization.incus = lib.mkIf pkgs.stdenv.isNixOS {
    enable = true;
    # Automatyczne dodanie zdefiniowanych użytkowników do grupy administracyjnej Incus.
    extraGroups = [ "incus-admin" ];
    users = userNames;
  };

  # Część użytkownika dla profilu "incus"
  home.packages = with pkgs-unstable; [
    # Narzędzie klienckie `inc` do zarządzania Incusem.
    incus
  ];
}

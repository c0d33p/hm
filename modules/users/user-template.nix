{ username, homeDirectory, fullName, email, profiles ? [], ... }:
{ config, pkgs, pkgs-unstable, lib, ... }:
{
  options.profiles = lib.mkOption { type = lib.types.listOf lib.types.str; default = profiles; };

  home-manager.users.${username} = {
    imports = [
      ../home-manager/common.nix
      ../home-manager/cli/atuin.nix
      ../home-manager/cli/git.nix
      ../home-manager/cli/zoxide.nix
      ../home-manager/terminals/kitty.nix
      ../home-manager/editors/neovim.nix
      ../home-manager/xdg.nix

      (lib.mkIf (lib.elem "firefox" config.profiles) ../home-manager/firefox.nix)
      (lib.mkIf (lib.elem "desktop-apps" config.profiles) ../../modules/shared/desktop-apps.nix)
      (lib.mkIf (lib.elem "gaming" config.profiles) ../../modules/shared/gaming.nix)
      (lib.mkIf (lib.elem "podman" config.profiles) ../../modules/shared/podman.nix)
      (lib.mkIf (lib.elem "incus" config.profiles) ../../modules/shared/incus.nix)
      (lib.mkIf (lib.elem "flatpak" config.profiles) ../../modules/shared/flatpak.nix)
      (lib.mkIf (lib.elem "cli-tools" config.profiles) ../../modules/shared/cli-tools.nix)
      (lib.mkIf (lib.elem "dev-env" config.profiles) ../../modules/shared/dev-env.nix)
    ];
    home = { inherit username homeDirectory; stateVersion = "25.05"; };
    programs.home-manager.enable = true;
  };

  (lib.mkIf pkgs.stdenv.isNixOS {
    users.users.${username} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      home = homeDirectory;
    };
    security.sudo.extraRules = [
      { users = [ username ]; commands = [{ command = "ALL"; options = [ "NOPASSWD" ]; }]; }
    ];
  })
}

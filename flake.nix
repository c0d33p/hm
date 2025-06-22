{
  description = "C0d33p home manager with flakes";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, disko, nix-flatpak, ... } @ inputs:
    let
      lib = nixpkgs.lib;

      users = {
        c0d33p = {
          homeDirectory = "/home/c0d33p";
          email = "c0d33p@zyztem";
        };
        mlewkowicz = {
            homeDirectory = "/home/mlewkowicz";
            email = "";
        };
      };

     hosts = {
         "zyztem-nixos" = {
        system = "x86_64-linux";
        profiles = [ "flatpak", "gaming", "firefox", "podman", "incus", "desktop-apps", "dev-env" ];
        users = [
          { username = "c0d33p"; homeDirectory = "/home/c0d33p"; }
        ] ;
        };
      };

      userTemplate = import ./modules/users/user-template.nix;

    mkNixosConfig = hostname: hostAttrs:
        let
            system = hostAttrs.system;
            pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
            userModules = lib.map (userOnHost:
                let userInfo = users."${userOnHost.username}"; in
                (userTemplate {
                    username = userOnHost.username;
                    homeDirectory = userOnHost.homeDirectory;
                    fullName = userInfo.fullName;
                    email = userInfo.email;
                    profiles = hostAttrs.profiles
                })
            )
        in
        nixpkgs.lib.nixosSystem {
            inherit system;
            specialArgs = {inherit pkgs-unstable; };
            modules = [
            { nixpkgs.config.allowUnfree = true; }

            # Moduły systemowe (zawsze aktywne dla NixOS)
            ./modules/nixos/core/system.nix
            disko.nixosModules.disko

            # Moduły współdzielone (część systemowa, włączana warunkowo przez profile)
            (lib.mkIf (lib.elem "cli-tools" hostAttrs.profiles) ./modules/shared/cli-tools.nix)
            (lib.mkIf (lib.elem "desktop-apps" hostAttrs.profiles) ./modules/shared/desktop-apps.nix)
            (lib.mkIf (lib.elem "flatpak" hostAttrs.profiles) ./modules/shared/flatpak.nix)
            (lib.mkIf (lib.elem "gaming" hostAttrs.profiles) ./modules/shared/gaming.nix)
            (lib.mkIf (lib.elem "podman" hostAttrs.profiles) ./modules/shared/podman.nix)
            (lib.mkIf (lib.elem "incus" hostAttrs.profiles) ./modules/shared/incus.nix)
            (lib.mkIf (lib.elem "dev-env" hostAttrs.profiles) ./modules/shared/dev-env.nix)


            # Konfiguracja specyficzna dla danego hosta (z katalogu /hosts)
            ./hosts/${hostname}/default.nix

            ] ++ userModules;
            };

        homeConfigurations = lib.foldl' (finalSet: hostname:
      mkHomeConfig = username: userAttrs:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${userAttrs.system};
          modules = [ (userTemplate { inferit username; inherit (userAttrs) homeDirectory; }) ];
          extraSpecialArgs = {
            pkgs-unstable = nixpkgs-unstable.legacyPackages.$(userAttrs.system)};
          };
        };

      mkNixosConfig = hostname: hostAttrs:
        let
          system = hostAttrs.system;

      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        zyztem-nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit pkgs-unstable; };
          modules = [
            home-manager.nixosModules.home-manager
            disko.nixosModules.disko
            nix-flatpak.nixosModules.nix-flatpak

            ./hosts/zyztem-nixos/default.nix

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit pkgs-unstable nix-flatpak;  };
                users.c0d33p = import ./hosts/zyztem-nixos/home.nix;
              };
            }
          ];
        };
      };
    };
}

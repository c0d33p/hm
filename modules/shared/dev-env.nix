{ pkgs, ... }:

{
  # Wszystkie te pakiety są instalowane w środowisku użytkownika.
  home.packages = with pkgs; [
    # --- Serwery Języków (LSP) ---
    nixd          # Nix
    lua-language-server
    rust-analyzer
    pyright       # Python
    nodePackages.typescript-language-server # TypeScript/JavaScript
    gopls         # Go
    clang-tools   # C/C++ (zawiera clangd)
    haskell-language-server

    # --- Formatery i Lintery ---
    nixpkgs-fmt   # Formater dla Nix
    black         # Formater dla Python
    rustfmt
    nodePackages.prettier # Formater dla Web Dev

    # --- Dodatkowe narzędzia deweloperskie ---
    nodePackages.eslint
    shellcheck
    yamllint
  ];
}

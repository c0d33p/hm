{ config, pkgs, lib, ... }:

{
  # Language servers and development tools
  home.packages = with pkgs; [
    # Language servers
    nixd                    # Nix LSP
    lua-language-server     # Lua LSP
    rust-analyzer          # Rust LSP
    pyright                # Python LSP
    nodePackages.typescript-language-server  # TypeScript/JavaScript
    gopls                  # Go LSP
    clang-tools           # C/C++ LSP (clangd)
    haskell-language-server # Haskell LSP
    
    # Formatters and linters
    nixpkgs-fmt           # Nix formatter
    black                 # Python formatter
    rustfmt              # Rust formatter
    nodePackages.prettier # JS/TS/HTML/CSS formatter
    
    # Additional development tools
    nodePackages.eslint   # JavaScript linter
    shellcheck           # Shell script linter
    yamllint             # YAML linter
  ];
}

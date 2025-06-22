{ ... }:

{
  # Włączenie podstawowej konfiguracji Basha przez Home Managera
  programs.bash = {
    enable = true;

    # Definiuje funkcję `update-config` do inteligentnej aktualizacji systemu.
    # Zostanie ona dodana do plików startowych powłoki każdego użytkownika.
    initExtra = ''
      update-config() {
        # Znajdź katalog z plikiem flake.nix, szukając w górę od bieżącego katalogu
        local FLAKE_DIR
        FLAKE_DIR=$(pwd)
        while [[ "$FLAKE_DIR" != "" && ! -e "$FLAKE_DIR/flake.nix" ]]; do
          FLAKE_DIR=''${FLAKE_DIR%/*}
        done

        if [ -z "$FLAKE_DIR" ]; then
          echo "BŁĄD: Nie znaleziono pliku flake.nix w bieżącym ani nadrzędnych katalogach." >&2
          return 1
        fi

        echo ">>> Znaleziono konfigurację w: $FLAKE_DIR"

        # Zapamiętaj bieżący katalog, aby do niego wrócić
        local CURRENT_DIR
        CURRENT_DIR=$(pwd)

        cd "$FLAKE_DIR"

        echo ">>> Sprawdzam typ systemu..."

        # Sprawdź, czy polecenie `nixos-rebuild` istnieje
        if command -v nixos-rebuild &> /dev/null; then
          local host
          host=$(hostname)
          echo ">>> System NixOS wykryty. Aktualizuję dla hosta: $host"
          # Używamy "$@" do przekazania wszystkich dodatkowych argumentów (np. --show-trace)
          sudo nixos-rebuild switch --flake .#''${host} "$@"
        else
          # Dla standalone HM, nazwa wyjścia musi być zdefiniowana w `standaloneHomes`
          # Prostszym podejściem jest użycie nazwy użytkownika, jeśli tak skonstruujesz flake'a.
          # Poniżej przykład, który wymagałby wpisu np. `c0d33p-laptop` w `standaloneHomes`
          echo ">>> Wykryto samodzielny Home Manager. Uruchom polecenie z konkretnym celem, np. .#c0d33p-laptop"
          # home-manager switch --flake .#twoja-nazwa-standalone "$@"
        fi

        # Wróć do pierwotnego katalogu
        cd "$CURRENT_DIR"
      }
    '';
  };
}

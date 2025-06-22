{ ... }:

{
  programs.atuin = {
    enable = true;
    enableBashIntegration = true; # Automatyczna integracja z Bash
    settings = {
      search_mode = "fuzzy";
      #sync_address = "https://api.atuin.sh";
    };
  };
}

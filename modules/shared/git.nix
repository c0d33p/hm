{ config, ... }:

{
  # Implementacja jest w całości oparta na Home Managerze,
  programs.git = {
    enable = true;
    # Dane `fullName` i `email` są pobierane z argumentów szablonu `user-template`.
    userName = config._module.args.fullName;
    userEmail = config._module.args.email;
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
  # `programs.git.enable` automatycznie dba o instalację pakietu `git`.
}

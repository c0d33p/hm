# Ten moduł otrzyma `fullName` i `email` od `user-template`
{ config, ... }:
{
  programs.git = {
    enable = true;
    userName = config._module.args.fullName;
    userEmail = config._module.args.email;
    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
    };
  };
}

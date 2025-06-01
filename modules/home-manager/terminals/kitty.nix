{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_moon";
    font.name = "JetBrainsMono Nerd Font";
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      copy_on_select = true;
      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";
      # Add more Kitty config options as needed
    };
  };
}


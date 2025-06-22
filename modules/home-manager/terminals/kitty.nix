{ ... }:

{
  programs.kitty = {
    enable = true;
    themeFile = "tokyo_night_moon";
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 11;
    };
    settings = {
      enable_audio_bell = false;
      confirm_os_window_close = 0;
      copy_on_select = true;
      clipboard_control = "write-clipboard read-clipboard write-primary read-primary";

    };
  }

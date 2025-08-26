{ pkgs, ...}:

{
  programs.alacritty = {
    enable = true;
    theme = "aura";
    settings = {
        terminal.shell = {
            program = "fish";
        };
        window = {
          opacity = 0.75;
        };
        font = {
          size = 14;
          normal = {
            family = "Iosevka Nerd Font";
          };
        };
    };
  };
}
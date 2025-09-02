{
  home-manager.users.tormented = { pkgs, config, ...}: {
    programs.fish = {
      enable = true;
      shellInit = ''
          zoxide init fish | source
          eval "$(micromamba shell hook --shell fish)"
          direnv hook fish | source
      '';
      interactiveShellInit = ''
          set fish_greeting
          fastfetch
          alias cd="z"
          alias ls="eza -1 -lh --icons --group-directories-first --no-permissions --no-user --time-style '+%_d %b %I:%M %p' --sort=modified --hyperlink -T -L=2"
      '';
    };
  };
}
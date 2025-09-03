{ ... }:
{
  programs = {
    fish = {
      enable = true;
      shellInit = ''
          zoxide init fish | source
          eval "$(micromamba shell hook --shell fish)"
      '';
      interactiveShellInit = ''
          set fish_greeting
          fastfetch
          alias cd="z"
          alias ls="eza -1 -lh --icons --group-directories-first --no-permissions --no-user --time-style '+%_d %b %I:%M %p' --sort=modified --hyperlink -T -L=2"
      '';
    };

    # Type `z <pat>` to cd to some directory
    zoxide.enable = true;

    # Better shell prompt!
    starship = {
      enable = true;
      settings = {
        username = {
          style_user = "blue bold";
          style_root = "red bold";
          format = "[$user]($style) ";
          disabled = false;
          show_always = true;
        };
        hostname = {
          ssh_only = false;
          ssh_symbol = "🌐 ";
          format = "on [$hostname](bold red) ";
          trim_at = ".local";
          disabled = false;
        };
      };
    };
  };
}

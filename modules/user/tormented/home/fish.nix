{
  home-manager.users.tormented = { pkgs, config, ...}: {
    programs.fish = {
      enable = true;
      shellInit = ''
          source (starship init fish --print-full-init | psub)
          zoxide init fish | source
          eval "$(micromamba shell hook --shell fish)"
          direnv hook fish | source
      '';
      interactiveShellInit = ''
          set fish_greeting
          fastfetch
          alias cd="z"
      '';
    };
  };
}
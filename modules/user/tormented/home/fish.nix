{
  home-manager.users.tormented = { pkgs, config, ...}: {
    programs.fish = {
      enable = true;
      shellInit = ''
          source (starship init fish --print-full-init | psub)
      '';
      interactiveShellInit = ''
          set fish_greeting
          fastfetch
          eval "$(micromamba shell hook --shell fish)"
      '';
    };
  };
}
{
  home-manager.users.tormented = { pkgs, config, ...}: {
    xdg.userDirs = {
      enable = true;
      createDirectories = true;
    };
  };
}
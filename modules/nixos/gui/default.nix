{
  imports = [
    ./hyprland.nix
    ./login.nix
  ];
  programs.xwayland.enable = true;
}

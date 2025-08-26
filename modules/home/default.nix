{ pkgs, ... }:

{
  home-manager.users.tormented = {
    imports = [
      ./fish.nix
      ./fastfetch.nix
      ./alacritty.nix
    ];
  };
}
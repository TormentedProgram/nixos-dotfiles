{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    jetbrains.idea-community
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
  };

  # Services natively supported by home-manager.
  # They can be configured in `services.*` instead of using home.packages.
  services = {
  };
}

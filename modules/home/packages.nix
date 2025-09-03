{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    omnix

    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    tree
    gnumake

    # Nix dev
    cachix
    nil # Nix language server
    nix-info
    nixpkgs-fmt

    # On ubuntu, we need this less for `man home-configuration.nix`'s pager to
    # work.
    less

    #User specific stuff
    xfce.thunar # file explorer
    thunderbird # email client
    xarchiver # lightweight archiving tool
    hyprlock # Lock screen
    dconf
    adwaita-icon-theme
    dunst # Notification Daemon
    orchis-theme 
    librewolf # Preferred browser
    yt-dlp
    vscodium # no telemetry fork of vscode used as primary text editor
    qimgv # Preferred image viewer
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    # Better `cat`
    bat.enable = true;
    # Type `<ctrl> + r` to fuzzy search your shell history
    fzf.enable = true;
    jq.enable = true;
    # Install btop https://github.com/aristocratos/btop
    btop.enable = true;
  };

  # Services natively supported by home-manager.
  # They can be configured in `services.*` instead of using home.packages.
  services = {
    udiskie = {
      enable = true;
      settings = {
        program_options = {
          file_manager = "${pkgs.xfce.thunar}/bin/thunar";
        };
      };
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1"; # tell system that i'm using wayland
}

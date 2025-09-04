{ pkgs, ... }:
{
  # Nix packages to install to $HOME
  #
  # Search for packages here: https://search.nixos.org/packages
  home.packages = with pkgs; [
    # Unix tools
    ripgrep # Better `grep`
    fd
    sd
    bc
    openssl # Required
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

    xfce.thunar # lightweight file explorer
    xarchiver # lightweight archiving tool
    dconf
    adwaita-icon-theme
    dunst # Notification Daemon
    orchis-theme

    pavucontrol # Volume Control Panel
    swww # Wallpaper Manager
    headsetcontrol # Headphone CLI

    # Clipboard
    wl-clipboard # Wayland clipboard
    cliphist
    wl-clip-persist
  ];

  # Programs natively supported by home-manager.
  # They can be configured in `programs.*` instead of using home.packages.
  programs = {
    eza.enable = true; # Better `ls`
    bat.enable = true; # Better `cat`
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

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
        };
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system"];
          uris = ["qemu:///system"];
        };
      };
    };

    gtk = {
      enable = true;
      theme = {
        name = "Orchis-Dark";
        package = pkgs.orchis-theme;
      };
      iconTheme = {
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
      };
    };

    home.sessionVariables.GTK_THEME = "Orchis-Dark";

    services.dunst = {
      enable = true;
      settings = {
        global = {
          width = 330;
          height = 110;
          follow = "keyboard";
          origin = "top-right";
          title = "Dunst";
          class = "dunst";
          force_xinerama = false;
          transparency = 10;
          frame_color = "#eceff1";
          font = "Iosevka Nerd Font Medium 11";
          corner_radius = 10;
          word_wrap = "yes";
          mouse_middle_click = "close_all";
          mouse_left_click = "close_current";
        };

        urgency_low = {
          background = "#1A1B26";
          foreground = "#ffffff";
          timeout = 2;
        };
        urgency_normal = {
          background = "#1A1B26";
          foreground = "#ffffff";
          timeout = 2;
        };
        urgency_critical = {
          background = "#2e1212ff";
          foreground = "#ffffff";
          frame_color = "#ff0000";
          timeout = 3;
        };
      };
    };
  };

  home.sessionVariables.NIXOS_OZONE_WL = "1"; # tell system that i'm using wayland
}

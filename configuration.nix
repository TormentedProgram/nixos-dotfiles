# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
    home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nix.settings = {
    download-buffer-size = 524288000; # 500 MiB
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "chromasen-nix"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Australia/Sydney";
  
  programs.fish.enable = true;  
  users.defaultUserShell = pkgs.fish;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  
  nixpkgs.config.allowUnfree = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tormented = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
      equibop
      vscodium
      steam
      protonup-qt
      lutris
      github-desktop
      tree
    ];
  };

  services.xserver = {
    enable = true;
    videoDrivers = ["nvidia"];
  };

  hardware = {
    graphics.enable = true;
    nvidia.open = false;
    nvidia.modesetting.enable = true;
  };

  home-manager.backupFileExtension = "bkp";  
  home-manager.users.tormented = { pkgs, ...}: {
    home.packages = with pkgs; [
    	  xfce.thunar
        xarchiver
        starship
        fish
        fastfetch
        wofi
        alacritty
        librewolf
        waybar
    ];
    home.stateVersion = "25.05";

    programs.fish = {
    	enable = true;
    	shellInit = ''
    	    source (starship init fish --print-full-init | psub)
    	'';
    	interactiveShellInit = ''
    	    set fish_greeting
    	    fastfetch
    	'';
    	shellAbbrs = {
    	    nix-update = "sudo nixos-rebuild switch";
    	};
    };

    programs.alacritty = {
    	enable = true;
    	settings = {
    	    terminal.shell = {
    	        program = "fish";
    	    };
    	};
    };
    
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland.enable = true;
      settings = {
        "$mod" = "SUPER";
        "$term" = "alacritty";
        "$browser" = "librewolf";
        "$discord" = "equibop";

        bind = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
          "$mod ALT, mouse:272, resizewindow"

          # keybinds
          "$mod, Q, exec, $term"
          "$mod, F, exec, $browser"
          "$mod, D, exec, $discord"
          "$mod, C, killactive"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let ws = i + 1;
              in [
                "$mod, code:1${toString i}, workspace, ${toString ws}"
                "$mod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
              ]
            )
            9)
        );
      };
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
  };
  
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    gedit
    wget
    git
  ];

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}


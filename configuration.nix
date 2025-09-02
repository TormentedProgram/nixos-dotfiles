# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

let
    home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/master.tar.gz;
    workspace-switch = pkgs.writeShellScriptBin "workspace-switch" ''
        monitorresult=$(${pkgs.hyprland}/bin/hyprctl -j monitors | ${pkgs.jq}/bin/jq --raw-output '.[] | select(.focused == true) | .id')
        result=$(( $monitorresult * 10 + $2 ))
        ${pkgs.hyprland}/bin/hyprctl dispatch $1 $result
    '';
    control-volume = pkgs.writeShellScriptBin "control-volume" ''
        current_volume=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{print $2}')
        volume_increase=5
        case "$1" in
          "+")
              # Increase volume
              if (( $(echo "$current_volume < 1.0" | bc -l) )); then
                  wpctl set-volume @DEFAULT_AUDIO_SINK@ $volume_increase%+
              else
                  wpctl set-volume @DEFAULT_AUDIO_SINK@ 100%
              fi
              ;;
          "-")
              # Decrease volume
              wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
              ;;
          *)
              echo "Invalid argument. Use '+' to increase or '-' to decrease volume."
              exit 1
              ;;
        esac
        percentage=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | awk '{printf "%.0f", $2 * 100}')%
        ${pkgs.gsound}/bin/gsound-play --file=$HOME/.system-assets/sounds/volume.ogg
        dunstify -r 1000 "VOLUME: $percentage"
    '';
    take-screenshot = pkgs.writeShellScriptBin "take-screenshot" ''
      # Create secure temporary file
      temp_screenshot=$(mktemp -t screenshot_XXXXXX.png)

      if [ -z "$XDG_PICTURES_DIR" ]; then
        XDG_PICTURES_DIR="$HOME/Pictures"
      fi

      if [ -z "$XDG_CONFIG_HOME" ]; then
        XDG_CONFIG_HOME="$HOME"
      fi

      confDir="''\${confDir:-$XDG_CONFIG_HOME}"
      save_dir="''\${2:-$XDG_PICTURES_DIR/Screenshots}"
      save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
      annotation_tool="swappy"
      annotation_args=("-o" "''\${save_dir}/''\${save_file}" "-f" "''\${temp_screenshot}")

      mkdir -p "$save_dir"

      # Fixes the issue where the annotation tool doesn't save the file in the correct directory
      if [[ "$annotation_tool" == "swappy" ]]; then
        swpy_dir="''\${confDir}/swappy"
        mkdir -p "$swpy_dir"
        echo -e "[Default]\nsave_dir=$save_dir\nsave_filename_format=$save_file" >"''\${swpy_dir}"/config
      fi

      # Add any additional annotation arguments
      [[ -n "''\${SCREENSHOT_ANNOTATION_ARGS[*]}" ]] && annotation_args+=("''\${SCREENSHOT_ANNOTATION_ARGS[@]}")

      # screenshot function, globbing was difficult to read and maintain
      take_screenshot() {
        local mode=$1
        shift
        local extra_args=("$@")

        # execute grimblast with given args
        if "grimblast" "''\${extra_args[@]}" copysave "$mode" "$temp_screenshot"; then
          if ! "''\${annotation_tool}" "''\${annotation_args[@]}"; then
            dunstify  "Screenshot Error" "Failed to open annotation tool"
            return 1
          fi
        else
          dunstify "Screenshot Error" "Failed to take screenshot"
          return 1
        fi
      }

      case $1 in
      p) # print all outputs
        take_screenshot "screen"
        ;;
      s) # drag to manually snip an area / click on a window to print it
        take_screenshot "area"
        ;;
      sf) # frozen screen, drag to manually snip an area / click on a window to print it
        take_screenshot "area" "--freeze"
        ;;
      m) # print focused monitor
        take_screenshot "output"
        ;;
      esac

      [ -f "$temp_screenshot" ] && rm "$temp_screenshot"

      if [ -f "''\${save_dir}/''\${save_file}" ]; then
        dunstify "''\${save_file}" "saved in ''\${save_dir}"
      fi
    '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
      (import "${home-manager}/nixos")
    ];

  nix.settings = {
    download-buffer-size = 524288000; # 500 MiB
    experimental-features = [ "nix-command" "flakes" ];
  };

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["tormented"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = ["tormented"];

  boot.kernelParams = [
    "systemd.mask=systemd-vconsole-setup.service"
    "systemd.mask=dev-tpmrm0.device" #this is to mask that stupid 1.5 mins systemd bug
    "nowatchdog" 
    "modprobe.blacklist=sp5100_tco" #watchdog for AMD
    "modprobe.blacklist=iTCO_wdt" #watchdog for Intel
    "nvidia-drm.modeset=1" # Enables kernel modesetting for the proprietary NVIDIA driver.
    "nouveau.modeset=0" # Disables modesetting for the open-source Nouveau driver, preventing conflicts with proprietary NVIDIA drivers.
    "kvm.enable_virt_at_load=0"
  ];

  boot.initrd = { 
    availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ ];
  };

  networking.firewall = {
    enable = true;
  };

  boot.loader.systemd-boot = {
    enable = true;
  };

  programs.partition-manager.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  # Use Zen kernel.
  boot.kernelPackages = pkgs.linuxPackages_zen;

  networking = {
    networkmanager.enable = true;
    hostName = "nixos"; # Define your hostname.
  }; 

  # Set your time zone.
  i18n.defaultLocale = "en_AU.UTF-8";
  services.automatic-timezoned.enable = true; #based on IP location

  services.udisks2.enable = true;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };
  
  programs.fish.enable = true;  
  users.defaultUserShell = pkgs.fish;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  services.blueman.enable = true;

  fonts = {
    fontDir.enable = true;
    fontconfig.useEmbeddedBitmaps = true;
    packages = with pkgs; [
      ubuntu_font_family
      liberation_ttf
      noto-fonts
      fira-code
      noto-fonts-cjk-sans
      jetbrains-mono
      nerd-fonts.iosevka
      nerd-fonts.jetbrains-mono # unstable
      nerd-fonts.fira-code # unstable
      nerd-fonts.fantasque-sans-mono #unstable
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];

    fontconfig = {
      defaultFonts = {
        serif = [  "Liberation Serif" "Noto Serif CJK JP" "Noto Serif CJK KR" "Noto Serif CJK SC" "Noto Serif CJK TC" "Noto Serif CJK HK" ];
        sansSerif = [ "Ubuntu"" Noto Sans CJK JP" "Noto Sans CJK KR" "Noto Sans CJK SC" "Noto Sans CJK TC" "Noto Sans CJK HK" ];
        monospace = [ "Ubuntu Mono" ];
      };
    };
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "nvidia-x11"
      "nvidia-settings"
      "steam"
      "steam-unwrapped"
      "chapterskip"
      "evafast"
      "cuda_cudart" #lazy ollama shit
      "libcublas"
      "cuda_cccl"
      "cuda_nvcc"
      "open-webui"
    ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  	xwayland.enable = true;
    withUWSM = true; # recommended for most users
  };

  xdg.mime = {
    enable = true;
    defaultApplications = {
      "text/html" = "librewolf.desktop";
      "x-scheme-handler/http" = "librewolf.desktop";
      "x-scheme-handler/https" = "librewolf.desktop";
      "x-scheme-handler/about" = "librewolf.desktop";
      "x-scheme-handler/unknown" = "librewolf.desktop";
    };
  };

  xdg.portal = {
    enable = true;
    wlr.enable = false;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
    ];
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal
    ];
  };

  programs.xwayland.enable = true;

  programs.xfconf.enable = true;
  services.gvfs.enable = true;
  services.tumbler.enable = true; # Thumbnail support for images
  
  programs.thunar = {
    enable = true;
    
    plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];
  };

  services.displayManager.gdm.enable = true;
  users.users.tormented = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [ 
      "wheel" 
      "networkmanager"
      "libvirtd"
      "scanner"
      "lp"
      "video" 
      "input" 
      "audio"  
    ];
    packages = with pkgs; [
      equibop
      vscodium
      steam
      libqalculate
      protonup-qt
      gsound
      lutris
      umu-launcher
      rustup
      onlyoffice-desktopeditors
      mcpelauncher-ui-qt
      nicotine-plus
      micromamba
      prismlauncher
      cava
      teams-for-linux
      gittyup
      vala
      pinta
      xfce.tumbler
      dolphin-emu
      hueadm
      xfce.xfce4-settings
      kdePackages.kdenlive
      krita
      ffmpegthumbnailer
      obs-studio
      tree
      feishin
      navidrome
    ];
  };
  
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true; # Show battery charge of Bluetooth devices
        };
      };
    };

    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        vaapiVdpau
        libvdpau
        libvdpau-va-gl 
        nvidia-vaapi-driver
        vdpauinfo
        libva
        libva-utils	
      ];
  	};

    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.beta;
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita-dark";
  };

  security.sudo = 
  let
    inherit (lib) mkForce mkDefault getExe';
  in {
    enable = true;
    extraConfig = ''
      Defaults lecture = never
      Defaults pwfeedback
    '';

    extraRules = [
      {
        groups = [ "wheel" ];

        commands = [
          # allow reboot and shutdown without password
          {
            command = getExe' pkgs.systemd "reboot";
            options = [ "NOPASSWD" ];
          }
          {
            command = getExe' pkgs.systemd "shutdown";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bkp";  
  home-manager.users.tormented = { pkgs, config, ...}: {
    home.packages = with pkgs; [
    	xfce.thunar
      thunderbird
      xarchiver
      hyprlock
      dconf
      adwaita-icon-theme
      dunst
      orchis-theme
      librewolf
      yt-dlp
      vscodium
      qimgv
    ];
    home.stateVersion = "25.05";

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

    services.udiskie = {
      enable = true;
      settings = {
        program_options = {
            file_manager = "${pkgs.xfce.thunar}/bin/thunar";
        };
      };
    };

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
    
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      xwayland = {
        enable = true;
      };

      settings = {
        env = [
          "LIBVA_DRIVER_NAME,nvidia"
          "__GLX_VENDOR_LIBRARY_NAME,nvidia"
          "__GL_VRR_ALLOWED,1"
          "WLR_DRM_NO_ATOMIC,1"
          "NIXOS_OZONE_WL,1"
          "XDG_CURRENT_DESKTOP,Hyprland"
          "XDG_SESSION_TYPE,wayland"
          "XDG_SESSION_DESKTOP,Hyprland"
          "QT_QPA_PLATFORM,wayland"
          "GTK_THEME,Orchis-Dark"
          "QT_STYLE_OVERRIDE,adwaita-dark"
        ];

        "$mod" = "SUPER";
        "$term" = "alacritty";
        "$browser" = "librewolf";
        "$discord" = "equibop";
        "$filemanager" = "thunar";
      
        exec-once = [
          "pkill swww;sleep .5 && swww-daemon && swww img '$HOME/.system-assets/images/current-wallpaper.jpg'"
          "pkill waybar;sleep .5 && waybar"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "wl-clip-persist --clipboard regular &"
          "systemctl --user start hyprpolkitagent"
          "hyprctl setcursor Adwaita 28" # oh my god im gonna kms </3
          "navidrome"
          "thunderbird"
        ];

        general = {
          gaps_in = 4;
          gaps_out = 10;

          resize_on_border = true;

          border_size = 2;
          layout = "dwindle";
        };

        xwayland = {
          force_zero_scaling = true;
        };

        animations = {
          enabled = true;
          bezier = [
            "wind, 0.05, 0.9, 0.1, 1.05"
            "winIn, 0.1, 1.1, 0.1, 1.1"
            "winOut, 0.3, -0.3, 0, 1"
            "liner, 1, 1, 1, 1"
          ];
          animation = [
            "windows, 1, 6, wind, slide"
            "windowsIn, 1, 6, winIn, slide"
            "windowsOut, 1, 5, winOut, slide"
            "windowsMove, 1, 5, wind, slide"
            "border, 1, 1, liner"
            "borderangle, 1, 30, liner, loop"
            "fade, 1, 10, default"
            "workspaces, 1, 5, wind"
          ];
        };

        decoration = {
          rounding = 9;

          blur = {
            enabled = true;
            size = 6;
            passes = 3;
            ignore_opacity = true;
            new_optimizations = true;
            xray = false;
          };

          shadow = {
            enabled = false;
          };
        };
	
	      monitor = [
          "DP-1, 2560x1440@240,0x0,1.6"
          "HDMI-A-2, 1920x1080@144,1600x0,1.2"
        ];	

        workspace = [
          "1, monitor:DP-1, default:true"
          "2, monitor:DP-1"
          "3, monitor:DP-1"
          "4, monitor:DP-1"
          "5, monitor:DP-1"
          "6, monitor:DP-1"
          "7, monitor:DP-1"
          "8, monitor:DP-1"
          "9, monitor:DP-1"
          "10, monitor:DP-1"
          "11, monitor:HDMI-A-2, default:true"
          "12, monitor:HDMI-A-2"
          "13, monitor:HDMI-A-2"
          "14, monitor:HDMI-A-2"
          "15, monitor:HDMI-A-2"
          "16, monitor:HDMI-A-2"
          "17, monitor:HDMI-A-2"
          "18, monitor:HDMI-A-2"
          "19, monitor:HDMI-A-2"
          "20, monitor:HDMI-A-2"
        ];

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        ecosystem = {
          no_donation_nag = true;
          no_update_news = true;
        };
        
        cursor = {
          warp_on_change_workspace = 1;
          no_warps = true;
        };

        windowrulev2 = [
          "center,class:^(jetbrains-.*)$,title:^(splash)$,floating:1"
          "nofocus,class:^(jetbrains-.*)$,title:^(splash)$,floating:1"
          "noborder,class:^(jetbrains-.*)$,title:^(splash)$,floating:1"

          "stayfocused,class:^(jetbrains-.*)$,title:^( )$,floating:1"
          "noborder,class:^(jetbrains-.*)$,title:^( )$,floating:1"

          "nofocus,class:^(jetbrains-.*)$,title:^(win.*)$,floating:1"
          
          "opacity 0.85 0.85,class:^([Tt]hunar)$"
          "opacity 0.90 0.90,class:^([Tt]hunderbird)$"
          "opacity 0.90 0.90,class:^([Dd]unst)$"
          "opacity 0.95 0.95,class:^(org.prismlauncher.PrismLauncher)$"
          "opacity 0.95 0.95,class:^(codium)$"
          "opacity 0.90 0.90,class:^(equibop)$"
          "opacity 0.95 0.95,class:^(com.github.gittyup.)$"
          "opacity 0.90 0.90,class:^(feishin)$"
          "opacity 0.80 0.80,class:^(xarchiver)$"
          "opacity 0.80 0.80,class:^(qt5ct)$"
          "opacity 0.80 0.80,class:^(qt6ct)$"
          "opacity 0.80 0.80,class:^(kvantummanager)$"
          "opacity 0.80 0.70,class:^(org.pulseaudio.pavucontrol)$"
          "opacity 0.80 0.70,class:^(blueman-manager)$"
          "opacity 0.80 0.70,class:^(nm-applet)$"
          "opacity 0.80 0.70,class:^(nm-connection-editor)$"
          "opacity 0.80 0.70,class:^(org.kde.polkit-kde-authentication-agent-1)$"
          "opacity 0.80 0.70,class:^(polkit-gnome-authentication-agent-1)$"
          "opacity 0.80 0.70,class:^(org.freedesktop.impl.portal.desktop.gtk)$"
          "opacity 0.80 0.70,class:^(org.freedesktop.impl.portal.desktop.hyprland)$"
          "opacity 0.70 0.70,class:^(steamwebhelper)$"

          "opacity 0.80 0.80,class:^(com.github.tchx84.Flatseal)$"
          "opacity 0.80 0.80,class:^(com.obsproject.Studio)$ # Obs-Qt"
          "opacity 0.80 0.80,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
          "opacity 0.80 0.80,class:^(yad)$ # Protontricks-Gtk"

          "float,class:^(org.kde.dolphin)$,title:^(Progress Dialog — Dolphin)$"
          "float,class:^(org.kde.dolphin)$,title:^(Copying — Dolphin)$"
          "float,class:^([Tt]hunar)$,title:^(File Operation Progress)$"
          "size 50% 50%,class:^(librewolf)$,title:^(Save Image)$"
          "float,class:^(xarchiver)$"
          "float,title:.*[Ww]inetricks.*"
          "float,title:^(About Mozilla Firefox)$"
          "float,class:^(VirtualBox Machine)$"
          "float,class:^([Aa]lacritty)$"
          "size 72% 70%,class:^([Aa]lacritty)$"
          "opacity 1.0, 1.0,class:^([Aa]lacritty)$"
          "float,class:^(qimgv)$"

          "size 50% 50%,class:^(qimgv)$"

          "float,class:^(mpv)$"
          "float,class:^(qt5ct)$"
          "float,class:^(qt6ct)$"
          "float,class:^(org.pulseaudio.pavucontrol)$"
          
          "float,class:^(.blueman-manager-wrapped)$"
          "size 50% 50%,class:^(.blueman-manager-wrapped)$"

          "float,class:^(nm-applet)$"
          "float,class:^(nm-connection-editor)$"
          "float,class:^(org.kde.polkit-kde-authentication-agent-1)$"

          "float,class:^(net.davidotek.pupgui2)$ # ProtonUp-Qt"
          "float,class:^(yad)$ # Protontricks-Gtk"

          "float,title:^(Open)$"
          "float,title:^(Choose Files)$"
          "float,title:^(Save As)$"
          "float,title:^(Confirm to replace files)$"
          "float,title:^(File Operation Progress)$"
          "float,class:^(xdg-desktop-portal-gtk)$"
        ];

        debug = {
          disable_logs = false;
        };

        binde = [
          " , xf86audioraisevolume, exec, ${control-volume}/bin/control-volume +"
          " , xf86audiolowervolume, exec, ${control-volume}/bin/control-volume -"
        ];

        bindm = [
          # mouse movements
          "$mod, mouse:272, movewindow"
          "$mod, mouse:273, resizewindow"
        ];

        bind = [
          # keybinds
          "$mod, Q, exec, $term"
          "$mod, F, exec, $browser"
          "$mod, D, exec, $discord"
          "$mod, E, exec, $filemanager"
	        "$mod, S, exec, rofi -show drun"
          "$mod, C, killactive"
          "$mod Shift, C, exec, kill $(${pkgs.hyprland}/bin/hyprctl activewindow -j | jq -r '.pid')"
          " , f11, fullscreen"
          "$mod Shift, S, exec, take-screenshot sf"
          "$mod, W, togglefloating"
          "$mod, V, exec, cliphist list | rofi -dmenu | cliphist decode | wl-copy"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
          builtins.concatLists (builtins.genList (i:
              let 
                workspace = i + 1;
              in [
                "$mod, code:1${toString i}, exec, workspace-switch workspace ${toString workspace}"
                "$mod SHIFT, code:1${toString i}, exec, workspace-switch movetoworkspace ${toString workspace}"
              ]
            )
            9)
        );
      };
      extraConfig = "
        layerrule = blur,rofi
        layerrule = blur,waybar
      ";
    };

    home.sessionVariables.NIXOS_OZONE_WL = "1";
    home.sessionVariables.QML_IMPORT_PATH = "${pkgs.hyprland-qt-support}/lib/qt-6/qml";
  };
  
  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.localBinInPath = true;
  environment.variables = {
    EDITOR = "nano";
    TERMINAL = "alacritty";
    GC_INITIAL_HEAP_SIZE = "32M";
    DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
  };
  environment.systemPackages = with pkgs; [
    headsetcontrol
    workspace-switch
    control-volume
    take-screenshot
    gedit
    bat
    bash
    bc
    wget
    curl
    hyprcursor
    nix-diff
    pkg-config
    openssl
    hypridle
    jq
    gnome-themes-extra
    gsettings-desktop-schemas
    glib
    cliphist
    wl-clip-persist
    hyprland-qt-support # for hyprland-qt-support
    clang
    git
    imagemagick
    gvfs
    swww
    ffmpeg
    wl-clipboard
    hyprpolkitagent
    pavucontrol
    grimblast
    swappy
  ];
  
  system.stateVersion = "25.11"; # Did you read the comment?
}

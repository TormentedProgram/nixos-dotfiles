{ pkgs, ... }:
{
  programs.hyprland = {
    enable = true;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
  	xwayland.enable = true;
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
}

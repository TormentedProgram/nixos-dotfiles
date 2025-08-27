{ pkgs, lib, ... }:

{
  home-manager.users.tormented = { pkgs, config, ...}: {
    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "top";
          modules-center = [ "hyprland/workspaces" ];
          modules-left = [
            "custom/startmenu"
            "custom/arrow6"
            "pulseaudio"
            "cpu"
            "memory"
            "custom/arrow7"
            "hyprland/window"
          ];
          modules-right = [
            "custom/arrow4"
            "custom/exit"
            "battery"
            "custom/arrow2"
            "tray"
            "custom/arrow1"
            "clock"
          ];

          "hyprland/workspaces" = {
            format = "{name}";
            format-icons = {
              default = " ";
              active = " ";
              urgent = " ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };
          "clock" = {
            format = '' {:L%I:%M %p}'';
            tooltip = true;
            tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
          };
          "hyprland/window" = {
            max-length = 22;
            separate-outputs = false;
          };
          "memory" = {
            interval = 5;
            format = " {}%";
            tooltip = true;
          };
          "cpu" = {
            interval = 5;
            format = " {usage:2}%";
            tooltip = true;
          };
          "disk" = {
            format = " {free}";
            tooltip = true;
          };
          "network" = {
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-ethernet = " {bandwidthDownOctets}";
            format-wifi = "{icon} {signalStrength}%";
            format-disconnected = "󰤮";
            tooltip = false;
          };
          "tray" = {
            spacing = 12;
          };
          "pulseaudio" = {
            format = "{icon} {volume}% {format_source}";
            format-bluetooth = "{volume}% {icon} {format_source}";
            format-bluetooth-muted = "󰝟 {icon} {format_source}";
            format-muted = "󰝟 MUTED";
            format-source = " {volume}%";
            format-source-muted = " MUTED";
            format-icons = {
              headphone = "";
              hands-free = "";
              headset = "";
              phone = "";
              portable = "";
              car = "";
              default = [
                ""
                ""
                ""
              ];
            };
            on-click = "sleep 0.1 && pavucontrol";
            on-click-middle = "sleep 0.1 && wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
          };
          "custom/exit" = {
            tooltip = false;
            format = "";
            on-click = "sleep 0.1 && hyprlock";
          };
          "custom/startmenu" = {
            tooltip = false;
            format = "";
            on-click = "sleep 0.1 && rofi -show drun";
          };
          "battery" = {
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = "󰂄 {capacity}%";
            format-plugged = "󱘖 {capacity}%";
            format-icons = [
              "󰁺"
              "󰁻"
              "󰁼"
              "󰁽"
              "󰁾"
              "󰁿"
              "󰂀"
              "󰂁"
              "󰂂"
              "󰁹"
            ];
            on-click = "";
            tooltip = false;
          };
          "custom/arrow1" = {
            format = "";
          };
          "custom/arrow2" = {
            format = "";
          };
          "custom/arrow4" = {
            format = "";
          };
          "custom/arrow6" = {
            format = "";
          };
          "custom/arrow7" = {
            format = "";
          };
        }
      ];

      style = lib.concatStrings [
        ''
          * {
            font-family: Iosevka Nerd Font;
            font-size: 16px;
            border-radius: 0px;
            border: none;
            min-height: 0px;
          }
          window#waybar {
            background: rgba(31, 35, 53, 0.8);
            color: #e9e9f4;
          }
          #workspaces button {
            padding: 0px 5px;
            background: transparent;
            color: rgba(162, 119, 255, 1);
          }
          #workspaces button.active {
            color: rgba(97, 254, 203, 1);
            background: rgba(16, 16, 16, 0.9);
          }
          #workspaces button:hover {
            color: #e9e9f4;
          }
          tooltip {
            background: rgba(28, 28, 28, 0.7);
            border: 1px solid #e9e9f4;
            border-radius: 12px;
          }
          tooltip label {
            color: #e9e9f4;
          }
          #window {
            padding: 0px 10px;
          }
          #pulseaudio, #cpu, #memory {
            padding: 0px 10px;
            background: rgba(162, 119, 255, 1);
            color: rgba(28, 28, 28, 0.7);
          }
          #custom-startmenu {
            color: #4d4f68;
            padding: 0px 14px;
            font-size: 20px;
            background: #e7c3ff;
          }
          #network, #battery,
          #custom-exit {
            background: rgba(97, 254, 203, 1);
            color: rgba(28, 28, 28, 0.7);
            padding: 0px 10px;
          }
          #tray {
            background: #4d4f68;
            color: rgba(28, 28, 28, 0.7);
            padding: 0px 10px;
          }
          #clock {
            font-weight: bold;
            padding: 0px 10px;
            color: rgba(28, 28, 28, 0.7);
            background: #c3fffe;
          }
          #custom-arrow1 {
            font-size: 24px;
            color: #c3fffe;
            background: #4d4f68;
          }
          #custom-arrow2 {
            font-size: 24px;
            color: #4d4f68;
            background: rgba(97, 254, 203, 1);
          }
          #custom-arrow4 {
            font-size: 24px;
            color: rgba(97, 254, 203, 1);
            background: transparent;
          }
          #custom-arrow6 {
            font-size: 24px;
            color: #e7c3ff;
            background: rgba(162, 119, 255, 1);
          }
          #custom-arrow7 {
            font-size: 24px;
            color: rgba(162, 119, 255, 1);
            background: transparent;
          }
        ''
      ];
    };
  };
}
{ pkgs, ...}:

{
  programs.fastfetch = {
    enable = true;
    settings =
      {
        logo = {
          source = "nixos";
          padding = {
            right = 4;
          };
        };
        display = {
          size = {
            binaryPrefix = "si";
          };
          color = "blue";
          separator = "  ";
        };
        modules = [
          {
            type = "custom";
            format = "{#1}[{#}Time]";
          }
          {
            type = "datetime";
            key = "󰅐 Date";
            format = "{1}-{3}-{11}";
          }
          {
            type = "uptime";
            key = "󰅐 Uptime";
          }
          "break"
          {
            type = "custom";
            format = "{#1}[{#}Packages]";
          }
          {
            type = "packages";
            key = "󰏖 Packages";
            format = "{all}";
          }
          "break"
          {
            type = "custom";
            format = "{#1}[{#}Desktop Environment]";
          }
          {
            type = "de";
            key = "󰧨 DE";
          }
          {
            type = "wm";
            key = "󱂬 WM";
          }
          {
            type = "wmtheme";
            key = "󰉼 Theme";
          }
          {
            type = "display";
            key = "󰹑 Resolution";
          }
          {
            type = "shell";
            key = "󰞷 Shell";
          }
          {
            type = "terminalfont";
            key = "󰛖 Font";
          }
          "player"
          "media"
          "break"
          {
            type = "custom";
            format = "{#1}[{#}Hardware]";
          }
          {
            type = "cpu";
            key = "󰻠 CPU";
          }
          {
            type = "gpu";
            key = "󰢮 GPU";
          }
          {
            type = "memory";
            key = "󰍛 Memory";
          }
        ];
      };
  };
}
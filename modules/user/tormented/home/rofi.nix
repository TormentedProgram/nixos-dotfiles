{
  home-manager.users.tormented = { pkgs, config, ...}: {
    programs.rofi = {
      enable = true;
      package = pkgs.rofi-wayland;
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          font = "Iosevka Nerd Font Medium 14";

          bg0 = mkLiteral "rgba(26, 27, 38, 0.8)";
          bg1 = mkLiteral "rgba(31, 35, 53, 0.8)";
          bg2 = mkLiteral "rgba(36, 40, 59, 0.8)";
          bg3 = mkLiteral "rgba(65, 72, 104, 0.8)";
          fg0 = mkLiteral "#c0caf5";
          fg1 = mkLiteral "#a9b1d6";
          fg2 = mkLiteral "#737aa2";
          red = mkLiteral "rgba(162, 119, 255, 0.9)";
          green = mkLiteral "#9ece6a";
          yellow = mkLiteral "#e0af68";
          blue = mkLiteral "#7aa2f7";
          magenta = mkLiteral "#9a7ecc";
          cyan = mkLiteral "#4abaaf";

          accent = mkLiteral "@red";
          urgent = mkLiteral "@yellow";

          background-color = mkLiteral "transparent";
          text-color = mkLiteral "@fg0";

          margin = 0;
          padding = 0;
          spacing = 0;
        };

        "element-icon, element-text, scrollbar" = {
          cursor = mkLiteral "pointer";
        };

        "window" = {
          location = mkLiteral "northwest";
          width = mkLiteral "400px";

          background-color = mkLiteral "@bg1";
          border = mkLiteral "1px";
          border-color = mkLiteral "@bg3";
          border-radius = mkLiteral "6px";
        };

        "inputbar" = {
          spacing = mkLiteral "8px";
          padding = mkLiteral "4px 8px";
          children = map mkLiteral [ "icon-search" "entry" ];

          background-color = mkLiteral "@bg0";
        };

        "icon-search, entry, element-icon, element-text" = {
          vertical-align = mkLiteral "0.5";
        };

        "textbox" = {
          padding = mkLiteral "4px 8px";
          background-color = mkLiteral "@bg2";
        };

        "listview" = {
          padding = mkLiteral "4px 0px";
          lines = 12;
          columns = 1;
          scrollbar = mkLiteral "true";
          fixed-height = mkLiteral "false";
          dynamic = mkLiteral "true";
        };

        "element" = {
          padding = mkLiteral "4px 8px";
          spacing = mkLiteral "8px";
        };

        "element normal urgent" = {
          text-color = mkLiteral "@urgent";
        };

        "element normal active" = {
          text-color = mkLiteral "@accent";
        };
        
        "element alternate active" = {
          text-color = mkLiteral "@accent";
        };

        "element selected" = {
          text-color = mkLiteral "@bg1";
          background-color = mkLiteral "@accent";
        };

        "element selected urgent" = {
          background-color = mkLiteral "@urgent";
        };

        "element-icon" = {
          size = mkLiteral "0.8em";
        };

        "element-text" = {
          text-color = mkLiteral "inherit";
        };

        "scrollbar" = {
          handle-width = mkLiteral "4px";
          handle-color = mkLiteral "@fg2";
          padding = mkLiteral "0 4px";
        };
      };
    };
  };
}
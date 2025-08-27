{ pkgs, lib, ... }:

{
  home-manager.users.tormented = { pkgs, config, ...}: {
    services.hyprshell = {
      enable = true;
      systemd.args = "-v";
      style = ''
        :root {
          --border-color: rgba(255, 255, 255, 0.6);
          --border-color-active: rgba(120, 245, 255, 0.9);

          --bg-color: #2c2e3e;
          --bg-color-hover: rgba(40, 40, 50, 1);

          --border-radius: 12px;
          --border-size: 2px;
          --border-style: solid;
          --border-style-secondary: dashed;

          --text-color: rgba(245, 245, 245, 1);

          --window-padding: 2px;
      }


      .monitor {
          background: #2c2e3e;
          box-shadow: inset 0 0 10px rgba(255, 255, 255, 0.5);
      }

      .workspace {
          background: #1A1B26);
          box-shadow: inset 0 0 10px rgba(255, 255, 255, 0.5);
      }

      .workspace:hover {
          box-shadow: inset 0 0 10px rgba(190, 245, 255, 0.7);
      }

      .workspace.active {
          box-shadow: inset 0 0 10px rgba(190, 245, 255, 0.7);
      }

      .client {
          background: unset;
          box-shadow: inset 0 0 10px rgba(255, 255, 255, 0.5);
      }

      .client.active {
          background: #2c2e3e;
          box-shadow: inset 0 0 10px rgba(190, 245, 255, 0.7);
      }

      .client:hover {
          background: #2c2e3e;
          box-shadow: inset 0 0 10px rgba(190, 245, 255, 0.7);
      }

      .client-image {
      }


      .launcher {
          background: rgba(255, 255, 255, 0.15);
          box-shadow: inset 0 0 25px rgba(255, 255, 255, 0.5);
      }

      .launcher-input {
          background: unset;
          border-radius: 10px;
          background: rgba(255, 255, 255, 0.05);
          box-shadow: inset 0 0 8px rgba(255, 255, 255, 0.5);
      }

      .launcher-input:focus-within {
          box-shadow: inset 0 0 15px rgba(190, 245, 255, 0.7);
          outline: var(--border-size, 3px) var(--border-style, solid) var(--border-color-active);
      }

      .launcher-results {
      }

      .launcher-item {
          background: unset;
          box-shadow: inset 0 0 12px rgba(255, 255, 255, 0.5);
          border: 1px var(--border-style, solid) rgba(255, 255, 255, 0.6);
      }

      .launcher-item:hover {
          background: #2c2e3e;
          box-shadow: inset 0 0 10px rgba(190, 245, 255, 0.7);
      }

      .launcher-exec {
      }

      .launcher-key {
      }

      .launcher-plugins {
      }

      .launcher-plugin {
          background: unset;
          box-shadow: inset 0 0 20px rgba(255, 255, 255, 0.5);
          border: var(--border-size, 3px) var(--border-style, solid) rgba(255, 255, 255, 0.6);
      }

      .launcher-plugin:hover {
          background: #2c2e3e;
          box-shadow: inset 0 0 20px rgba(190, 245, 255, 0.7);
      }
      '';
      
      settings = {
        kill_bind = "ctrl+shift+alt, h";
        windows = {
          items_per_row = 5;
          overview = {
            strip_html_from_workspace_title = true;
            key = "alt_l";
            modifier = "alt";
            launcher = {
              default_terminal = "alacritty";
              max_items = 9;
              launch_modifier = "ctrl";
              show_when_empty = true;
              plugins.websearch = {
                  engines = [{
                      name = "DuckDuckGo";
                      url = "https://duckduckgo.com/?q={}";
                      key = "d";
                  }
                  {
                      name = "YouTube";
                      url = "https://www.youtube.com/results?search_query={}";
                      key = "y";
                  }];
              };
              plugins.terminal = {};
              plugins.calc = {};
              plugins.path = {};
            };
          };
          switch = {
            modifier = "ctrl";
            show_workspaces = true;
          };
        };
      };
    };
  };
}
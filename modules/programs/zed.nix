{config, ...}: {
  programs.zed-editor = {
    enable = true;
    userSettings = {
      theme = "One Dark";
      features = {
        copilot = false;
      };
      telemetry = {
        metrics = false;
      };
      vim_mode = false;
      soft_wrap = "editor_width";

      buffer_font_size = 24;
      buffer_font_family = "MesloLGM Nerd Font Mono";

      ui_font_size = 24;

      terminal = {
        shell = {
          program = config.globals.shell;
        };
      };

      lsp = {
        rust-analyzer = {
          binary = {
            path_lookup = true;
          };
        };
      };
      ssh_connections = [
        {
          host = "wksv";
        }
      ];
    };
    userKeymaps = [
      {
        context = "Editor";
        bindings = {
          ctrl-shift-tab = "pane::ActivatePrevItem";
          ctrl-tab = "pane::ActivateNextItem";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "ctrl-`" = "workspace::ToggleBottomDock";
        };
      }
    ];
  };
}

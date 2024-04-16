# TODO: use nix variables to simplify config.
{config, ...}: {
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local act = wezterm.action
      local config = wezterm.config_builder()

      config.keys = {
        { key = 'q', mods = 'ALT|SHIFT', action = act.CloseCurrentPane { confirm = false } },
        { key = 't', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
        { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
        { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
        { key = 'c', mods = 'CTRL|SHIFT', action = act.CopyTo 'ClipboardAndPrimarySelection' },
        { key = 'f', mods = 'CTRL|SHIFT', action = act.Search { CaseInSensitiveString = "" } },
        { key = 'v', mods = 'CTRL', action = act.PasteFrom 'Clipboard' },
        { key = '1', mods = 'ALT', action = act.ActivateTab(0) },
        { key = '2', mods = 'ALT', action = act.ActivateTab(1) },
        { key = '3', mods = 'ALT', action = act.ActivateTab(2) },
        { key = '4', mods = 'ALT', action = act.ActivateTab(3) },
        { key = '5', mods = 'ALT', action = act.ActivateTab(4) },
        { key = '6', mods = 'ALT', action = act.ActivateTab(5) },
        { key = '7', mods = 'ALT', action = act.ActivateTab(6) },
        { key = '8', mods = 'ALT', action = act.ActivateTab(7) },
        { key = 'LeftArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(-1) },
        { key = 'RightArrow', mods = 'SHIFT|ALT', action = act.MoveTabRelative(1) },
        { key = '_', mods = 'SHIFT|ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
        { key = '|', mods = 'SHIFT|ALT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
        { key = 'h', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Left' },
        { key = 'j', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Down' },
        { key = 'k', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Up' },
        { key = 'l', mods = 'SHIFT|ALT', action = act.ActivatePaneDirection 'Right' },
        { key = 'm', mods = 'SHIFT|ALT', action = act.TogglePaneZoomState },
        -- { key = 'd', mods = 'SHIFT|ALT', action = act.ShowDebugOverlay },
        { key = '-', mods = 'CTRL', action = act.DecreaseFontSize },
        { key = '=', mods = 'CTRL', action = act.IncreaseFontSize },
      }

      -- config.color_scheme = "Hardcore" -- Black bg
      -- config.color_scheme = "github_dark_dimmed"
      config.disable_default_key_bindings = true
      config.default_prog = { '${config.globals.shell}', '-l' }
      config.cursor_blink_rate = 0
      config.default_cursor_style = 'BlinkingBlock'
      config.hide_mouse_cursor_when_typing = false
      config.force_reverse_video_cursor = true
      config.inactive_pane_hsb = { brightness = 0.7 }
      -- config.font = wezterm.font 'Inconsolata LGC Nerd Font Mono'
      config.font = wezterm.font 'MesloLGM Nerd Font Mono'
      config.font_size = 14
      config.selection_word_boundary = " \t\n{}[]()\"'`" .. "│▍"

      -- A little bolder font is cool.
      config.front_end = "WebGpu"

      return config
    '';

    colorSchemes.github_dark_dimmed = {
      # https://github.com/projekt0n/github-theme-contrib/blob/main/themes/wezterm/github_dark_dimmed.toml
      background = "#22272e";
      foreground = "#adbac7";

      cursor_bg = "#adbac7";
      cursor_border = "#adbac7";
      cursor_fg = "#22272e";

      selection_bg = "#2e4c77";
      selection_fg = "#adbac7";

      ansi = [
        "#545d68"
        "#f47067"
        "#57ab5a"
        "#c69026"
        "#539bf5"
        "#b083f0"
        "#39c5cf"
        "#909dab"
      ];
      brights = [
        "#636e7b"
        "#ff938a"
        "#6bc46d"
        "#daaa3f"
        "#6cb6ff"
        "#dcbdfb"
        "#56d4dd"
        "#cdd9e5"
      ];
    };
  };
}

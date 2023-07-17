{ config, pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local act = wezterm.action

      return {
        disable_default_key_bindings = true,
        keys = {
          -- TODO move tab with mouse :)
          { key = 'q', mods = 'ALT|SHIFT', action = act.CloseCurrentPane { confirm = false } },
          { key = 't', mods = 'ALT', action = act.SpawnTab 'CurrentPaneDomain' },
          { key = 'Tab', mods = 'CTRL', action = act.ActivateTabRelative(1) },
          { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
          { key = 'c', mods = 'CTRL|SHIFT', action = wezterm.action.CopyTo 'ClipboardAndPrimarySelection' },
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
          { key = 'f', mods = 'SHIFT|ALT', action = act.TogglePaneZoomState },
        },
        color_scheme = "Sonokai (Gogh)",
        default_prog = { '${pkgs.fish}/bin/fish', '-l' },
        cursor_blink_rate = 0,
        default_cursor_style = 'BlinkingBlock',
        hide_mouse_cursor_when_typing = false,
        force_reverse_video_cursor = true,
        inactive_pane_hsb = { brightness = 0.7 },
        window_background_image = '${config.home.sessionVariables.XDG_WALLPAPERS_DIR}/1.png',
        window_background_image_hsb = { brightness = 0.07 },
      }
    '';
  };
}

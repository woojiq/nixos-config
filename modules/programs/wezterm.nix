{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local act = wezterm.action

      return {
        disable_default_key_bindings = true,
        keys = {
          -- TODO move tab
          { key = 'q', mods = 'ALT', action = wezterm.action.CloseCurrentTab { confirm = false } },
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
        },
        color_scheme = "Sonokai (Gogh)",
        default_prog = { '${pkgs.fish}/bin/fish', '-l' },
        cursor_blink_rate = 0,
      }
    '';
  };
}

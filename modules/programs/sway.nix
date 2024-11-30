{
  pkgs,
  config,
  lib,
  ...
}: let
  # Check hyprland/home.nix for examples.
  browser = "${pkgs.google-chrome}/bin/google-chrome-stable";
  terminal = "${config.programs.wezterm.package}/bin/wezterm";
  wofi = "${pkgs.wofi}/bin/wofi";
in let
  mainMod = "Mod4";
  # "$shiftMod" = "Mod4 + SHIFT";
  altMod = "Mod1";
in {
  wayland.windowManager.sway = {
    enable = true;
    config = {
      inherit terminal;
      modifier = "${mainMod}";
      menu = "${wofi}";

      keybindings = lib.mkOptionDefault {
        "${mainMod}+t" = "exec ${config.wayland.windowManager.sway.config.terminal}";
        "${mainMod}+b" = "exec ${browser}";
        "${mainMod}+q" = "kill";
        "${mainMod}+Escape" = "exec ~/.config/wofi/power-menu.sh";
        "${altMod}+Tab" = "workspace back_and_forth"; # Not exactly what I want.
      };

      input = {
        "type:touchpad" = {
          xkb_layout = "us,ua";
          xkb_options = "grp:win_space_toggle";
          tap = "enabled";
          drag = "enabled";
          natural_scroll = "enabled";
          scroll_factor = "0.2";
          pointer_accel = "-0.25"; # hyprland's sensitivity
        };

        "type:keyboard" = {
          repeat_rate = "25";
          repeat_delay = "220";
        };
      };
    };
    extraOptions = ["--unsupported-gpu"];
  };
}

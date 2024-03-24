{
  pkgs,
  lib,
  config,
  ...
}: let
  browser = config.globals.browser;
  terminal = config.globals.terminal;
  bar = "${pkgs.waybar}/bin/waybar";
  wofi = "${pkgs.wofi}/bin/wofi";
  wob = "${pkgs.wob}/bin/wob";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";
  light = "${pkgs.light}/bin/light";
  grim = "${pkgs.grim}/bin/grim";
  slurp = "${pkgs.slurp}/bin/slurp";
  swappy = "${pkgs.swappy}/bin/swappy";
  notify-send = "${pkgs.libnotify}/bin/notify-send";
  emote = "${pkgs.emote}/bin/emote";
  hyprctl = "${pkgs.hyprland}/bin/hyprctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  awk = "${pkgs.gawk}/bin/awk";
  wl-clip-persist = lib.getExe pkgs.wl-clip-persist;
  blueman-applet = "${pkgs.blueman}/bin/blueman-applet";
  hyprpaper = "${pkgs.hyprpaper}/bin/hyprpaper";
in let
  volumePt = "0.04";
  brightnessPt = "5";

  doubleMove = {
    num,
    dir ? "r",
  }: "${hyprctl} dispatch movetoworkspace ${toString num} && ${hyprctl} dispatch movewindow ${dir}";

  genBind = mod: cmd: l: r:
    lib.lists.concatMap (
      i: ["${mod}, ${toString i}, ${cmd}, ${toString i}"]
    ) (lib.lists.range l r);

  getVolumeScript = pkgs.writeShellScript "get-volume-script" ''
    ans=$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@)
    if echo "$ans" | grep -q MUTED; then
      echo 0
    else
      echo "$ans" | ${awk} -F': ' '{printf "%.0f\n", $2*100}'
    fi
  '';

  # wofi --show drun | xargs -Ioutput hyprctl dispatch exec output
  wofiWithFilter = pkgs.writeShellScript "wofi-with-filter" ''
    res=$(${wofi} --show drun)
    filter=("telegram-desktop --")
    # filter=()
    for name in "''${filter[@]}"; do
      if [ "$res" = "$name" ]; then
        exit
      fi
    done
    ${hyprctl} dispatch exec "$res"
  '';
in let
  hyprpaperConf = let
    wallpapers = "${config.home.sessionVariables.WALLPAPERS_DIR}/1.jpg";
  in ''
    preload = ${wallpapers}
    wallpaper = eDP-1,${wallpapers}
    splash = false
    # ipc = off
  '';

  hyprlandSettings = {
    "$mainMod" = "SUPER";
    "$shiftMod" = "SUPER + SHIFT";
    "$altMod" = "ALT";

    env = [
      # Wob setup
      "WOBSOCK, $XDG_RUNTIME_DIR/wob.sock"
      # Make cursor visible on other monitors too.
      "WLR_NO_HARDWARE_CURSORS, 1"
    ];

    exec-once = [
      bar
      blueman-applet
      emote
      hyprpaper
      "${wl-clip-persist} --clipboard regular"

      # Workspace setup: https://wiki.hyprland.org/Configuring/Dispatchers/#executing-with-rules
      "[workspace 1 silent] ${browser}"
      "[workspace 2 silent] ${terminal}"

      "rm -f $WOBSOCK && mkfifo $WOBSOCK && tail -f $WOBSOCK | ${wob}"
    ];

    general = {
      layout = "dwindle";
      # gaps_in = 0;
      gaps_out = 0;
    };

    dwindle = {
      # Does it really do smth?)
      pseudotile = true;
      force_split = 2;
    };

    monitor = [
      "eDP-1, 1920x1080@60, 0x0, 1"
      # 1440
      "DP-1, 3840x2160@60, 0x-1728, 1.25"
    ];

    xwayland = {
      force_zero_scaling = true;
    };

    input = {
      kb_layout = "us,ua";
      kb_options = "grp:win_space_toggle";
      repeat_rate = 25;
      repeat_delay = 220;
      sensitivity = "-0.25";
      follow_mouse = 2;
      touchpad = {
        natural_scroll = true;
        tap-to-click = true;
        scroll_factor = 0.2;
        middle_button_emulation = true;
      };
    };

    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 4;
      workspace_swipe_distance = 130;
    };

    animations = {
      enabled = false;
    };

    decoration = {
      rounding = 5;
    };

    misc = {
      focus_on_activate = true;
      disable_hyprland_logo = true;
      disable_splash_rendering = true;
    };

    bind =
      [
        "$mainMod, q, killactive"
        "$mainMod, m, fullscreen, 1"
        "$mainMod, f, togglefloating"
        "$mainMod, p, pin"
        "$mainMod, d, exec, ${wofiWithFilter}"
        "$shiftMod, d, exec, ${wofi} --show run"
        "$mainMod, t, exec, ${terminal}"
        "$mainMod, b, exec, ${browser}"
        "$mainMod, escape, exec, ~/.config/wofi/power-menu.sh"
        "$shiftMod, escape, exit,"
        "$mainMod, code:60, exec, ${emote}"

        "$altMod, Tab, focuscurrentorlast"

        "$mainMod, 0, togglespecialworkspace,"
        # Other mainMod bindings are generated using `genBind` function.

        "$shiftMod, 1, exec, ${doubleMove {num = 1;}}"
        # Other shiftMod bindings are generated using `genBind` function.

        "$shiftMod, 9, movetoworkspacesilent, 9"
        "$shiftMod, 0, movetoworkspacesilent, special"
        "$shiftMod, right, movetoworkspace, +1"
        "$shiftMod, left, movetoworkspace, -1"

        "$mainMod, h, workspace, -1"
        "$mainMod, l, workspace, +1"
        "$shiftMod, h, movefocus, l"
        "$shiftMod, l, movefocus, r"
        "$shiftMod, k, movefocus, u"
        "$shiftMod, j, movefocus, d"

        ", XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle && ${getVolumeScript} > $WOBSOCK"
        ", XF86MonBrightnessDown, exec, ${light} -U ${brightnessPt} && light -G | cut -d'.' -f1 > $WOBSOCK"
        ", XF86MonBrightnessUP, exec, ${light} -A ${brightnessPt} && light -G | cut -d'.' -f1 > $WOBSOCK"
        ", XF86AudioNext, exec, ${playerctl} next"
        ", XF86AudioPrev, exec, ${playerctl} previous"
        ", XF86AudioPlay, exec, ${playerctl} play-pause"

        ", Print, exec, ${grim} -g \"$(${slurp})\" - | ${swappy} -f - && ${notify-send} 'Saved to ~/Pictures/Screenshots'"
        "$altMod, Print, exec, ${grim} - | ${swappy} -f - && ${notify-send} 'Saved to ~/Pictures/Screenshots'"
      ]
      ++ (genBind "$mainMod" "workspace" 1 9)
      ++ (genBind "$shiftMod" "movetoworkspace" 2 8);

    bindm = [
      # 272 - LMB, 273 - RBM
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    binde = [
      # https://github.com/francma/wob
      ", XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ ${volumePt}- && ${getVolumeScript} > $WOBSOCK"
      ", XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ ${volumePt}+ && ${getVolumeScript} > $WOBSOCK"
    ];

    windowrulev2 = [
      # Autocompletion, etc, take hyprland focus
      "noborder, class:^(jetbrains-idea)(.*)$"
      # Wrong telegram scale after opening tg image/video viewer: https://github.com/hyprwm/Hyprland/issues/839
      "float,class:^(org.telegram.desktop|telegramdesktop)$,title:^(Media viewer)$"

      # Fixes dropdown windows may disappear if you hover them:
      # https://github.com/hyprwm/Hyprland/issues/2661#issuecomment-1821639125
      "stayfocused, title:^()$,class:^(steam)$"
      "minsize 1 1, title:^()$,class:^(steam)$"

      "tile, title:^(.*)(NETCONF|NetConf)(.*)$"
    ];
  };
in {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = hyprlandSettings;
    plugins = [
      # Alt-Tab switch mode doesn't work.
      # inputs.hycov.packages.${pkgs.system}.hycov
    ];
  };

  xdg.configFile."hypr/hyprpaper.conf".text = hyprpaperConf;

  services = {
    swayidle = {
      enable = true;
      timeouts = [
        {
          timeout = 600;
          command = "${hyprctl} dispatch dpms off";
          resumeCommand = "${hyprctl} dispatch dpms on";
        }
        {
          timeout = 1800;
          # TODO make script to lock screen before hibernation.
          # And use it in wofi module too.
          command = "${hyprctl} dispatch dpms on && ${systemctl} hibernate";
        }
      ];
      systemdTarget = "hyprland-session.target";
    };
  };
}

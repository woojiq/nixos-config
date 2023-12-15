{
  pkgs,
  config,
  lib,
  ...
}: let
  browser = "${pkgs.google-chrome}/bin/google-chrome-stable";
  terminal = "${config.home.sessionVariables.TERMINAL}";
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
in let
  # Pseudo Alt-Tab with dmenu: https://github.com/hyprwm/Hyprland/discussions/830#discussioncomment-3868467
  hyprlandConf = let
    getVolumeScript = pkgs.writeShellScript "get-volume-script" ''
      ans=$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@)
      if echo "$ans" | grep -q MUTED; then
        echo 0
      else
        echo "$ans" | ${awk} -F': ' '{printf "%.0f\n", $2*100}'
      fi
    '';

    doubleMove = {
      num,
      dir ? "r",
    }: "${hyprctl} dispatch movetoworkspace ${toString num} && ${hyprctl} dispatch movewindow ${dir}";

    genBind = mod: cmd: l: r:
      lib.concatMapStringsSep "\n" (
        i: "bind = ${mod}, ${toString i}, ${cmd}, ${toString i}"
      ) (lib.lists.range l r);
  in ''
    exec-once = ${bar}
    exec-once = ${blueman-applet}
    exec-once = ${emote}
    exec-once = ${wl-clip-persist} --clipboard regular

    # Workspace setup: https://wiki.hyprland.org/Configuring/Dispatchers/#executing-with-rules
    exec-once = [workspace 1 silent] ${browser}
    exec-once = [workspace 2 silent] ${terminal}

    # Wob setup
    env = WOBSOCK, $XDG_RUNTIME_DIR/wob.sock
    exec-once = rm -f $WOBSOCK && mkfifo $WOBSOCK && tail -f $WOBSOCK | ${wob}

    $mainMod = SUPER
    $shiftMod = SUPER + SHIFT
    $altMod = ALT

    general {
    	layout = dwindle
    	# gaps_in = 0
    	gaps_out = 0
    }

    dwindle {
      # Does it really do smth?)
      pseudotile = true
      force_split = 2
    }

    monitor = eDP-1, 1920x1080@60, 0x0, 1

    xwayland {
      force_zero_scaling = true
    }

    input {
    	kb_layout = us,ua
    	kb_options = grp:win_space_toggle
    	repeat_rate = 25
    	repeat_delay = 220
    	sensitivity = -0.25
    	follow_mouse = 2
    	touchpad {
    		natural_scroll = true
    		tap-to-click = true
    		scroll_factor = 0.2
    		middle_button_emulation = true
    	}
    }

    gestures {
    	workspace_swipe = true
    	workspace_swipe_fingers = 4
    	workspace_swipe_distance = 130
    }

    animations {
    	enabled = false
    }

    decoration {
    	rounding = 5
    }

    misc {
      focus_on_activate = true
      disable_hyprland_logo = true
      disable_splash_rendering = true
    }

    bind = $mainMod, q, killactive
    bind = $mainMod, m, fullscreen, 1
    bind = $mainMod, f, togglefloating
    bind = $mainMod, p, pin
    bind = $mainMod, d, exec, ${wofi} --show drun | xargs -Ioutput hyprctl dispatch exec output
    bind = $shiftMod, d, exec, ${wofi} --show run
    bind = $mainMod, t, exec, ${terminal}
    bind = $mainMod, b, exec, ${browser}
    bind = $mainMod, escape, exec, ~/.config/wofi/power-menu.sh
    bind = $shiftMod, escape, exit,
    bind = $mainMod, code:60, exec, ${emote}

    bind = $altMod, Tab, focuscurrentorlast

    ${genBind "$mainMod" "workspace" 1 9}
    bind = $mainMod, 0, togglespecialworkspace,

    bind = $shiftMod, 1, exec, ${doubleMove {num = 1;}}
    ${genBind "$shiftMod" "movetoworkspace" 2 8}
    bind = $shiftMod, 9, movetoworkspacesilent, 9
    bind = $shiftMod, 0, movetoworkspacesilent, special
    bind = $shiftMod, right, movetoworkspace, +1
    bind = $shiftMod, left, movetoworkspace, -1

    bind = $mainMod, h, workspace, -1
    bind = $mainMod, l, workspace, +1
    bind = $shiftMod, h, movefocus, l
    bind = $shiftMod, l, movefocus, r
    bind = $shiftMod, k, movefocus, u
    bind = $shiftMod, j, movefocus, d

    # 272 - LMB, 273 - RBM
    bindm = $mainMod, mouse:272, movewindow
    bindm = $mainMod, mouse:273, resizewindow

    # https://github.com/francma/wob
    $volume_pt = 0.04
    $brightness_pt = 5
    binde = , XF86AudioLowerVolume, exec, ${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ $volume_pt- && ${getVolumeScript} > $WOBSOCK
    binde = , XF86AudioRaiseVolume, exec, ${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ $volume_pt+ && ${getVolumeScript} > $WOBSOCK
    bind = , XF86AudioMute, exec, ${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle && ${getVolumeScript} > $WOBSOCK
    bind = , XF86MonBrightnessDown, exec, ${light} -U $brightness_pt && light -G | cut -d'.' -f1 > $WOBSOCK
    bind = , XF86MonBrightnessUP, exec, ${light} -A $brightness_pt && light -G | cut -d'.' -f1 > $WOBSOCK
    bind = , XF86AudioNext, exec, ${playerctl} next
    bind = , XF86AudioPrev, exec, ${playerctl} previous
    bind = , XF86AudioPlay, exec, ${playerctl} play-pause

    bind = , Print, exec, ${grim} -g "$(${slurp})" - | ${swappy} -f - && ${notify-send} "Saved to ~/Pictures/Screenshots"
    bind = $altMod, Print, exec, ${grim} - | ${swappy} -f - && ${notify-send} "Saved to ~/Pictures/Screenshots"

    # Autocompletion, etc, take hyprland focus
    windowrulev2 = noborder, class:^(jetbrains-idea)(.*)$
    # Wrong telegram scale after opening tg image/video viewer: https://github.com/hyprwm/Hyprland/issues/839
    windowrulev2=float,class:^(org.telegram.desktop|telegramdesktop)$,title:^(Media viewer)$

    windowrulev2=float,class:^(gnome-pomodoro)$
  '';
in {
  wayland.windowManager.hyprland = {
    enable = true;
    # TODO use settings instead of extraConfig
    extraConfig = hyprlandConf;
    enableNvidiaPatches = true;
  };

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
          command = "${systemctl} hibernate";
        }
      ];
      systemdTarget = "hyprland-session.target";
    };
  };
}

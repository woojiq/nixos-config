{ pkgs, config, ... }:

let
  browser = "${pkgs.google-chrome}/bin/google-chrome-stable";
  browser_pure = "Google Chrome";
  terminal = "${pkgs.wezterm}/bin/wezterm";
  terminal_pure = "wezterm";
  bar = "${config.programs.waybar.package}/bin/waybar";
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
  sleep = "${pkgs.coreutils}/bin/sleep";
  hyprctl = "${config.wayland.windowManager.hyprland.package}/bin/hyprctl";
  systemctl = "${pkgs.systemd}/bin/systemctl";
  awk = "${pkgs.gawk}/bin/awk";
in
let
  cleanupScript = pkgs.writeShellScript "cleanup-script" ''
    ${sleep} 4
    ${hyprctl} keyword windowrule "workspace unset, ${browser_pure}"
    ${hyprctl} keyword windowrule "workspace unset, ${terminal_pure}"
  '';
  getVolumeScript = pkgs.writeShellScript "get-volume-script" ''
    ans=$(${wpctl} get-volume @DEFAULT_AUDIO_SINK@)
    if echo "$ans" | grep -q MUTED; then
      echo 0
    else
      echo "$ans" | ${awk} -F': ' '{printf "%.0f\n", $2*100}'
    fi
  '';
in
let
  # Pseudo Alt-Tab Definitely not Windows experience
  # https://github.com/hyprwm/Hyprland/discussions/830#discussioncomment-3868467
  hyprlandConf = ''
    exec-once = ${bar}
    exec-once = ${emote}

    # Workspace setup
    exec-once = ${hyprctl} keyword windowrule "workspace 1 silent, ${browser_pure}"
    exec-once = ${hyprctl} keyword windowrule "workspace 2 silent, ${terminal_pure}"
    exec-once = ${browser}
    exec-once = ${terminal}
    exec-once = ${cleanupScript.outPath}

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

    # misc {
    #   force_hypr_chan = true
    # }

    bind = $mainMod, q, killactive
    bind = $mainMod, m, fullscreen, 1
    bind = $mainMod, f, togglefloating
    bind = $mainMod, p, pin
    bind = $mainMod, d, exec, ${wofi} --show drun
    bind = $shiftMod, d, exec, ${wofi} --show run
    bind = $mainMod, t, exec, ${terminal}
    bind = $mainMod, b, exec, ${browser}
    bind = $mainMod, escape, exec, ~/.config/wofi/power-menu.sh
    bind = $shiftMod, escape, exit,
    bind = $mainMod, code:60, exec, ${emote}

    bind = $altMod, Tab, focuscurrentorlast

    bind = $mainMod, 1, workspace, 1
    bind = $mainMod, 2, workspace, 2
    bind = $mainMod, 3, workspace, 3
    bind = $mainMod, 4, workspace, 4
    bind = $mainMod, 5, workspace, 5
    bind = $mainMod, 6, workspace, 6
    bind = $mainMod, 7, workspace, 7
    bind = $mainMod, 8, workspace, 8
    bind = $mainMod, 9, workspace, 9

    bind = $shiftMod, 1, movetoworkspace, 1 
    bind = $shiftMod, 2, movetoworkspace, 2 
    bind = $shiftMod, 3, movetoworkspace, 3 
    bind = $shiftMod, 4, movetoworkspace, 4 
    bind = $shiftMod, 5, movetoworkspace, 5 
    bind = $shiftMod, 6, movetoworkspace, 6 
    bind = $shiftMod, 7, movetoworkspace, 7 
    bind = $shiftMod, 8, movetoworkspace, 8 
    bind = $shiftMod, 9, movetoworkspacesilent, 9 
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
  '';
in
{
  imports =
    [ (import ../../programs/waybar.nix) ] ++
    [ (import ../../programs/wob.nix) ];

  wayland.windowManager.hyprland = {
    enable = true;
    # TODO support nvidiaPatches here and in the nvidia.nix
    # TODO use settings instead of extraConfig
    extraConfig = hyprlandConf;
  };

  services = {
    swayidle = {
      enable = true;
      timeouts = [
        { timeout = 600; command = "${hyprctl} dispatch dpms off"; resumeCommand = "${hyprctl} dispatch dpms on"; }
        { timeout = 1800; command = "${systemctl} poweroff"; }
      ];
      systemdTarget = "hyprland-session.target";
    };
  };
}

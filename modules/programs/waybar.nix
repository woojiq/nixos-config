{pkgs, ...}: let
  light = "${pkgs.light}/bin/light";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
in {
  programs.waybar = {
    enable = true;

    settings.mainBar = {
      position = "top";
      layer = "top";
      modules-left = [
        "custom/arch-pill"
        "hyprland/workspaces"
        "cpu"
        # "temperature"
        "backlight"
        "idle_inhibitor"
      ];
      modules-center = [
        "tray"
        # "hyprland/window"
      ];
      modules-right = [
        "hyprland/language"
        "network"
        "battery"
        "wireplumber"
        "clock"
        "custom/power"
      ];
      "custom/arch-pill" = {
        format = "";
        on-click = "${pkgs.wofi}/bin/wofi --show drun";
        tooltip = false;
      };
      "hyprland/workspaces" = {
        format = "<span font='12'>{name}</span>";
        all-outputs = true;
        active-only = false;
        on-click = "activate";
        show-special = true;
      };
      "cpu" = {
        interval = 5;
        format = "<span foreground='#89b4fa'></span> {usage}%";
      };
      "temperature" = {
        critical-threshold = 80;
        format = "<span foreground='#eba0ac'></span> {temperatureC}°C";
        hwmon-path = "/sys/class/thermal/thermal_zone4/temp";
        interval = 2;
      };
      "tray" = {
        icon-size = 20;
        reverse-direction = true;
        spacing = 6;
        show-passive-items = true;
      };
      "hyprland/window" = {
        format = "{}";
        separate-outputs = true;
        max-length = 40;
      };
      "hyprland/language" = {
        format-en = "🇺🇸";
        format-uk = "🇺🇦";
        on-click = "hyprctl switchxkblayout keyd-virtual-device next";
      };
      "network" = {
        # interface = "wlan0",
        format = "Loading";
        format-wifi = " ";
        format-ethernet = "{ipaddr}/{cidr}  ";
        format-disconnected = "󰖪 ";
        tooltip-format = "{ifname} via {gwaddr} 󰩟 ";
        tooltip-format-wifi = "{essid}({signalStrength}%)\n{gwaddr} 󰩟 ";
        tooltip-format-ethernet = "{ifname}  ";
        tooltip-format-disconnected = "Disconnected";
        on-click = "sudo systemctl restart NetworkManager";
      };
      "battery" = {
        states = {
          good = 95;
          warning = 30;
          critical = 1;
        };
        format = "<span foreground='#a6e3a1'>{icon}</span> {capacity}%";
        format-icons = [
          " "
          " "
          " "
          " "
          " "
        ];
        format-charging = " <span foreground='#a6e3a1'>{icon}</span> {capacity}%";
      };
      "wireplumber" = {
        on-click = "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle";
        on-scroll-down = "${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 0.01+";
        on-scroll-up = "${wpctl} set-volume -l 1.0 @DEFAULT_AUDIO_SINK@ 0.01-";
        format = "{icon}  {volume}%";
        format-muted = "<span size='13000' foreground='#fab387'> </span>";
        format-icons = ["<span size='13000' foreground='#fab387'></span>"];
      };
      "backlight" = {
        "device" = "intel_backlight";
        "format" = "<span foreground='#f9e2af'>{icon}</span>  {percent}%";
        "states" = [
          0
          50
        ];
        "format-icons" = [
          ""
          ""
        ];
        "on-scroll-up" = "${light} -U 1";
        "on-scroll-down" = "${light} -A 1";
      };
      "idle_inhibitor" = {
        "format" = "<span foreground='#a2e8a2'>{icon}</span>";
        "format-icons" = {
          "activated" = " ";
          "deactivated" = " ";
        };
      };
      "clock" = {
        # https://github.com/Alexays/Waybar/wiki/Module:-Clock#example
        interval = 5;
        format = "<span foreground='#89dceb'> </span><span>{:%H:%M %d.%m}</span>";
        format-alt = "<span foreground='#cba6f7'> </span><span>{:%I:%M:%S %p %a %d %Y}</span>";
        tooltip-format = "<tt><small>{calendar}</small></tt>";
        calendar = {
          mode = "year";
          mode-mon-col = 3;
          weeks-pos = "right";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            days = "<span color='#ecc6d9'><b>{}</b></span>";
            weeks = "<span color='#99ffdd'><b>W{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
      };
      "custom/power" = {
        format = "⏻";
        on-click = "exec ~/.config/wofi/power-menu.sh";
        tooltip = false;
      };
    };

    style = ''
      @define-color bg-hover #1A1A28;
      @define-color bg #1E1E2E;
      @define-color blue #89B4FA;
      @define-color sky #89DCEB;
      @define-color red #F38BA8;
      @define-color pink #F5C2E7;
      @define-color lavender #B4BEFE;
      @define-color rosewater #F5E0DC;
      @define-color flamingo #F2CDCD;
      @define-color fg #D9E0EE;
      @define-color green #A6E3A1;
      @define-color dark-fg #161320;
      @define-color peach #FAB387;
      @define-color border @lavender;
      @define-color gray2 #6E6C7E;
      @define-color black4 #575268;
      @define-color black3 #302D41;
      @define-color maroon #EBA0AC;

      * {
        margin: 0;
        padding: 0;
        border-radius: 0;
        font-family: "FiraCode NerdFont", "SF Pro", "JetBrainsMono Nerd Font";
        font-size: 10pt;
        padding-bottom: 1px;
      }

      tooltip {
        background: @bg;
        border-radius: 7px;
        border: 2px solid @border;
      }

      window#waybar {
        background-color: transparent;
        color: @lavender;
      }

      window#waybar.empty {
        color: @pink;
        padding-left: 100px;
        padding-right: 100px;
      }

      #custom-arch-pill {
        margin: 5px;
        padding-left: 10px;
        padding-right: 15px;
        border-radius: 7px;
        background-color: @lavender;
        color: @dark-fg;
      }

      #mode {
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        border-radius: 7px;
        background-color: @bg;
        color: @peach;
      }

      #tray {
        margin: 5px;
        padding-left: 5px;
        padding-right: 5px;
        border-radius: 7px;
        background-color: @bg;
      }

      #language {
        margin: 5px;
        padding-left: 10px;
        padding-right: 9px;
        border-radius: 7px;
        background-color: @bg;
        color: @lavender;
      }

      #network {
        margin: 5px;
        padding-left: 10px;
        padding-right: 7px;
        border-radius: 7px;
        background-color: @bg;
        color: @sky;
      }
      #network.linked {
        color: @peach;
      }
      #network.disconnected,
      #network.disabled {
        color: @red;
      }

      #workspaces button {
        margin: 5px;
        padding: 0 4px;
        border-radius: 7px;
        color: @lavender;
        background-color: @bg;
      }

      #workspaces button.visible {
      }

      #workspaces button.active {
        border-radius: 10px;
        color: @dark-fg;
        background-color: @rosewater;
      }

      #wireplumber,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #idle_inhibitor,
      #battery {
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        border-radius: 7px;
        color: @lavender;
        background-color: @bg;
      }

      #window {
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        border-radius: 7px;
        color: @lavender;
        background-color: @bg;
      }

      #wireplumber.muted {
        background-color: @red;
        color: @dark-fg;
      }

      #clock {
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        border-radius: 7px;
        color: @lavender;
        background-color: @bg;
      }

      #custom-power {
        margin: 5px;
        padding-left: 10px;
        padding-right: 15px;
        border-radius: 7px;
        background-color: @maroon;
        color: @dark-fg;
      }
    '';
  };
}

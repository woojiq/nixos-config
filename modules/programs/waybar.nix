{ pkgs, user, ... }:

{
  home-manager.users.${user}.programs.waybar = {
    enable = true;

    settings.mainBar = {
      layer = "top";
      position = "top";
      modules-left = [
        "custom/arch-pill"
        "wlr/workspaces"
        "cpu"
        # "playerctl"
        "temperature"
      ];
      modules-center = [
        "tray"
        # "hyprland/window"
      ];
      modules-right = [
        "hyprland/language"
        "network"
        "battery"
        # "wireplumber"
        "pulseaudio"
        "clock"
        "custom/power"
      ];
      "custom/arch-pill" = {
        format = "";
        on-click = "${pkgs.wofi}/bin/wofi --show drun";
        tooltip = false;
      };
      "wlr/workspaces" = {
        # format = "<span font='11'>{name}</span>";
        format = "<span font='13'>{icon}</span>";
        format-icons = {
          "1" = "";
          "2" = "";
          # "3" = "";
          #  "4"="";
          #  "5"="";
          #  "6"="";
          #  "7"="";
          #  "8"="";
          #  "9"="";
          #  "10"="";
        };
        #all-outputs = true;
        active-only = false;
        on-click = "activate";
      };
      "cpu" = {
        interval = 5;
        format = "<span foreground='#89b4fa'></span> {usage}%";
      };
      # "custom/playerctl" = {
      #   format = "{icon}  <span>{}</span>";
      #   return-type = "json";
      #   max-length = 50;
      #   exec = "playerctl -a metadata --format '{\"text\": \"{{artist}} ~ {{markup_escape(title)}}\", \"tooltip\": \"{{playerName}} : {{markup_escape(title)}}\", \"alt\": \"{{status}}\", \"class\": \"{{status}}\"}' -F";
      #   on-click-middle = "playerctl play-pause";
      #   on-click = "playerctl previous";
      #   on-click-right = "playerctl next";
      #   format-icons = {
      #     Playing = "<span foreground='#94e2d5'></span>";
      #     Paused = "<span foreground='#f38ba8'></span>";
      #   };
      # };
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
      };
      "hyprland/window" = {
        format = "{}";
        separate-outputs = true;
        max-length = 40;
      };
      "hyprland/language" = {
        format-en = "🇺🇸";
        format-uk = "🇺🇦";
        on-click = "${pkgs.hyprland}/bin/hyprctl switchxkblayout keyd-virtual-device next";
      };
      "network" = {
        # interface = "wlan0",
        format = "Loading";
        format-wifi = " ";
        format-ethernet = "{ipaddr}/{cidr}  ";
        format-disconnected = "󰖪 ";
        tooltip-format = "{ifname} via {gwaddr}  ";
        tooltip-format-wifi = "{essid}({signalStrength}%)\n{gwaddr}  ";
        tooltip-format-ethernet = "{ifname}  ";
        tooltip-format-disconnected = "Disconnected";
        # on-click = "sudo systemctl restart NetworkManager";
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
        format-charging = " <span foreground='#a6e3a1'>{icon}</span>  {capacity}%";
      };
      "pulseaudio" = {
        on-click = "${pkgs.pamixer}/bin/pamixer set-sink-mute -t";
        on-scroll-down = "${pkgs.pamixer}/bin/pamixer -i 1";
        on-scroll-up = "${pkgs.pamixer}/bin/pamixer -d 1";
        format = "<span size='13000' foreground='#fab387'></span>  {volume}%";
        format-muted = "<span size='14000'>ﱝ</span>";
      };
      # "wireplumber" = {
      #   on-click = "pamixer set-sink-mute -t";
      #   on-scroll-down = "pamixer -i 1";
      #   on-scroll-up = "pamixer -d 1";
      #   format = "<span size='13000' foreground='#fab387'></span>  {volume}%";
      #   format-muted = "<span size='14000'>ﱝ</span>";
      # };
      "clock" = {
        interval = 5;
        format = "<span foreground='#89dceb'> </span><span>{:%H:%M %d.%m}</span>";
        format-alt = "<span foreground='#cba6f7'> </span><span>{:%I:%M:%S %p %a %d %Y}</span>";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        today-format = "<span color='#ff6699'><b><u>{}</u></b></span>";
        format-calendar = "<span color='#ecc6d9'><b>{}</b></span>";
        format-calendar-weeks = "<span color='#99ffdd'><b>W{:%U}</b></span>";
        format-calendar-weekdays = "<span color='#ffcc66'><b>{}</b></span>";
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
        min-height: 0;
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

      #pulseaudio,
      #cpu,
      #memory,
      #temperature,
      #backlight,
      #battery {
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        border-radius: 7px;
        color: @lavender;
        background-color: @bg;
      }

      #window,
      #custom-playerctl {
        margin: 5px;
        padding-left: 10px;
        padding-right: 10px;
        border-radius: 7px;
        color: @lavender;
        background-color: @bg;
      }

      #pulseaudio.muted {
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



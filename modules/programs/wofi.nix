{ pkgs, config, ... }:

let
  wofiSettings = {
    xoffset = 710;
    yoffset = 275;
    show = "drun";
    width = 500;
    height = 500;
    layer = "overlay";
    insensitive = true;
    prompt = "";
    allow_images = true;
    term = "${config.home.sessionVariables.TERMINAL}";

    key_down = "Tab";
    key_up = "ISO_LEFT_TAB";
    key_forward = "";
    key_backward = "";
  };

  wofiStyle = ''
    window {
    margin: 0px;
    border: 2px solid #414868;
    border-radius: 5px;
    background-color: #24283b;
    font-family: Fredoka One;
    font-size: 16px;
    }

    #input {
    margin: 5px;
    border: 1px solid #24283b;
    color: #c0caf5;
    background-color: #24283b;
    }

    #input image {
    	color: #c0caf5;
    }

    #inner-box {
    margin: 5px;
    border: none;
    background-color: #24283b;
    }

    #outer-box {
    margin: 5px;
    border: none;
    background-color: #24283b;
    }

    #scroll {
    margin: 0px;
    border: none;
    }

    #text {
    margin: 5px;
    border: none;
    color: #c0caf5;
    } 

    #entry:selected {
    	background-color: #414868;
    	font-weight: normal;
    }

    #text:selected {
    	background-color: #414868;
    	font-weight: normal;
    }
  '';
in
{
  programs.wofi = {
    enable = true;
    settings = wofiSettings;
    style = wofiStyle;
  };

  xdg.configFile = {
    "wofi/power-menu.sh" = {
      executable = true;
      text = ''
        # https://github.com/MatthiasBenaets/nixos-config/blob/9e799904e74d43a2c0ad1a8b6ac4db86993bf2dd/modules/programs/wofi.nix#L18
        entries="⏾  Suspend\n⭮  Reboot\n⏻  Shutdown"
        selected=$(echo -e $entries|${pkgs.wofi}/bin/wofi --dmenu --cache-file /dev/null --height 20% | awk '{print tolower($2)}')

        case $selected in
          suspend)
            exec systemctl suspend;;
          reboot)
            exec systemctl reboot;;
          shutdown)
            exec systemctl poweroff -i;;
        esac
      '';
    };
  };
}

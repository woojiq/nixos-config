{pkgs, ...}: let
  light = "${pkgs.light}/bin/light";
  hyprland = "${pkgs.hyprland}/bin/Hyprland";
in {
  environment = {
    loginShellInit = ''
      # if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      #   exec ${hyprland}
      # fi
      # Set minimum brightness value
      ${light} -N 5
    '';

    systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      wl-clip-persist
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  programs = {
    hyprland = {
      enable = true;
    };
    light.enable = true;
  };
}

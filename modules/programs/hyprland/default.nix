{pkgs, ...}: let
  brightnessctl = "${pkgs.brightnessctl}/bin/brightnessctl";
  hyprland = "${pkgs.hyprland}/bin/start-hyprland";
in {
  environment = {
    loginShellInit = ''
      # if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
      #   exec ${hyprland}
      # fi
      # Set minimum brightness value
      ${brightnessctl} -n 5
    '';

    systemPackages = with pkgs; [
      grim
      slurp
      wl-clipboard
      # wl-clip-persist
    ];
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };

  programs = {
    hyprland = {
      enable = true;
      # package = inputs.hyprland.packages.${pkgs.system}.default;
    };
  };
}

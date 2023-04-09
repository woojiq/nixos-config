{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "16x16";
    };
    settings = {
      urgency_low = {
        timeout = 2;
      };
      urgency_normal = {
        timeout = 3;
      };
      urgency_critical = {
        timeout = 5;
      };
    };
  };
  home.packages = with pkgs; [
    libnotify
  ];
}

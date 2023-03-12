{ pkgs, ... }:

{
  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
      size = "16x16";
    };
  };
  home.packages = with pkgs; [
    libnotify
  ];
}

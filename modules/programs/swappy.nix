{ pkgs, ... }:

let
  config = ''
    [Default]
    save_dir=$(${pkgs.xdg-user-dirs}/bin/xdg-user-dir SCREENSHOTS)
    early_exit=true
  '';
in
{
  home.packages = with pkgs; [
    swappy
  ];
  xdg.configFile."swappy/config".text = config;
}

{ pkgs, config, ... }:

let
  configIni = ''
    [Default]
    save_dir=${config.home.sessionVariables.SCREENSHOTS_DIR}
    early_exit=true
  '';
in
{
  home.packages = with pkgs; [
    swappy
  ];
  xdg.configFile."swappy/config".text = configIni;
}

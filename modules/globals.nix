{
  lib,
  pkgs,
  ...
}: {
  options.globals = with lib; {
    terminal = mkOption {type = types.pathInStore;};
    browser = mkOption {type = types.pathInStore;};
    shell = mkOption {type = types.pathInStore;};
  };

  config.globals = {
    terminal = "${pkgs.wezterm}/bin/wezterm";
    browser = "${pkgs.google-chrome}/bin/google-chrome-stable";
    shell = "${pkgs.fish}/bin/fish";
  };
}

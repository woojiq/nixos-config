{
  lib,
  pkgs,
  ...
}: {
  options.globals = with lib; {
    shell = mkOption {type = types.pathInStore;};
  };

  config.globals = {
    shell = "${pkgs.fish}/bin/fish";
  };
}

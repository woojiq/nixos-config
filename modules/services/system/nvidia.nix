{ pkgs, ... }:
{
  services.xserver = {
    videoDrivers = [ "nvidia" ];
  };
  hardware = {
    opengl.enable = true;
    nvidia.modesetting.enable = true;
  };
  programs.steam = {
    enable = true;
    # https://github.com/NixOS/nixpkgs/issues/236561#issuecomment-1581879353
    package = with pkgs; steam.override { extraPkgs = pkgs: [ attr ]; };
  };
}

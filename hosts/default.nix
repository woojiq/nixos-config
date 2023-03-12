{ user, nixpkgs, hyprland, home-manager }:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ (final: prev: { waybar = hyprland.packages.${system}.waybar-hyprland; }) ];
  };
in
{
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user pkgs;
    };
    modules = [
      hyprland.nixosModules.default
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user pkgs;
        };
        home-manager.users.${user} = {
          imports = [
            ./home.nix
          ];
        };
      }
    ];
  };
}

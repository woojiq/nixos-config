{ user, nixpkgs, home-manager, inputs }:

let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [ (final: prev: { waybar = inputs.hyprland.packages.${system}.waybar-hyprland; }) ];
  };
in
{
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user pkgs;
    };
    modules = [
      inputs.hyprland.nixosModules.default
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
          programs.helix.package = inputs.helix.packages.${system}.helix-dev;
        };
      }
    ];
  };
}

{ user, nixpkgs, home-manager, inputs }:

let
  swappyPatched = final: prev: {
    swappy = prev.swappy.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        ../patches/swappy-multi-layout.patch
      ];
    });
  };
in
let
  system = "x86_64-linux";
  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = [
      swappyPatched
    ];
  };
in
{
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user pkgs;
    };
    modules = [
      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user pkgs;
          helix-flake = inputs.helix.packages.${system}.default;
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

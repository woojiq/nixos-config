{
  user,
  nixpkgs,
  home-manager,
  inputs,
}: let
  system = "x86_64-linux";
in {
  laptop = nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = {
      inherit user inputs;
    };
    modules = [
      {
        nixpkgs = {
          config = {
            allowUnfree = true;
            permittedInsecurePackages = [];
          };

          overlays = [
            (import ../overlays)
          ];
        };
      }

      inputs.disko.nixosModules.disko
      ./disko-config.nix

      ./configuration.nix

      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit user inputs;
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

{
  description = "Personal NixOs Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs = inputs @ { self, nixpkgs, home-manager, hyprland }:
    let
      user = "woojiq";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit nixpkgs home-manager user hyprland;
        }
      );
    };
}

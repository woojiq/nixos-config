#
{
  description = "Personal NixOs Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "/home/woojiq/Hacks/src/nixpkgs/";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      # url = "github:pascalkuthe/helix/event_system";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # TODO Remove this after 0.9.22
    waybar = {
      url = "github:Alexays/Waybar/16f6d9dfa0c38d72e6c661334e4c9d7837b3a61d";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    home-manager,
    ...
  }: let
    user = "woojiq";
  in {
    nixosConfigurations = (
      import ./hosts {
        inherit nixpkgs home-manager user inputs;
      }
    );
  };
}

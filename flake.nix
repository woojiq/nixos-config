{
  description = "Personal NixOs Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/24.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "/home/woojiq/code/nixpkgs/";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      # We don't want to follow nixpkgs to be able to use cachix.
      # inputs.nixpkgs.follows = "nixpkgs";
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

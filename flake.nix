{
  description = "Personal NixOs Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "/home/woojiq/Documents/src/nixpkgs/";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix.url = "github:helix-editor/helix";
  };

  outputs = inputs @ { nixpkgs, home-manager, ... }:
    let
      user = "woojiq";
    in
    {
      nixosConfigurations = (
        import ./hosts {
          inherit nixpkgs home-manager user inputs;
        }
      );
    };
}

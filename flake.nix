{
  description = "Personal NixOs Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    # nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "/home/woojiq/code/nixpkgs/";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      # url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix/43bf7c2dc219606c64003aef21151f49f48d0939";
      # We don't want to follow nixpkgs to be able to use cachix.
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    # wezterm-nightly = {
    #   url = "github:wez/wezterm?dir=nix";
    #   # inputs.nixpkgs.follows = "nixpkgs";
    # };
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

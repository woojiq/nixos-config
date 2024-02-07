{
  description = "Personal NixOs Setup";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs.url = "/home/woojiq/code/nixpkgs/";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    helix = {
      url = "github:helix-editor/helix";
      # url = "github:pascalkuthe/helix/event_system";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # hyprland = {
    #   url = "github:hyprwm/Hyprland/refs/tags/v0.34.0";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
    # Unfortunately I cannot use hyprland plugins and use precompiled hyprland itself.
    # hycov = {
    #   url = "github:DreamMaoMao/hycov";
    #   inputs.hyprland.follows = "hyprland";
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

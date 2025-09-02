{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    doxx = {
      url = "github:bgreenwell/doxx";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
    in {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [ 
          ./configuration.nix 
          ./modules/user/tormented/home
          ./modules/user/tormented/home/scripts
          ./modules/user/tormented/scripts
          ./modules/user/tormented
          ./modules/system
          ./modules/system/scripts
        ];
      };
    };
}
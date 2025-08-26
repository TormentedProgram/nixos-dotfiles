{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
        ] ++ (
          let
            importAllNixFiles = dir: 
              builtins.map 
                (name: dir + "/${name}") 
                (builtins.attrNames (builtins.readDir dir));
          in
            importAllNixFiles ./modules/home ++ 
            importAllNixFiles ./modules/system
        );
      };
    };
}
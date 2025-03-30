{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    zen-browser.url = "github:MarceColl/zen-browser-flake";
    mms.url = "github:mkaito/nixos-modded-minecraft-servers";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    ...
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    nixosConfigurations.goingmerry = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/goingmerry/configuration.nix
        inputs.home-manager.nixosModules.default
      ];
    };
    nixosConfigurations.hitsugibune = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/hitsugibune/configuration.nix
      ];
    };
    nixosConfigurations.saberofxebec = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/saberofxebec/configuration.nix
      ];
    };
  };
}

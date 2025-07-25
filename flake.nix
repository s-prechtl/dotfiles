{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    mms.url = "github:mkaito/nixos-modded-minecraft-servers";
    agenix.url = "github:ryantm/agenix";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-stable,
    nix-darwin,
    nix-homebrew,
    ...
  } @ inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;
    formatter.aarch64-darwin = nixpkgs.legacyPackages.aarch64-darwin.alejandra;
    nixosConfigurations.goingmerry = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/goingmerry/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.nixos-hardware.nixosModules.framework-16-7040-amd
      ];
    };
    nixosConfigurations.hitsugibune = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/hitsugibune/configuration.nix
        inputs.agenix.nixosModules.default
      ];
    };
    nixosConfigurations.saberofxebec = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/saberofxebec/configuration.nix
        inputs.agenix.nixosModules.default
      ];
    };
    nixosConfigurations.karasumaru = nixpkgs-stable.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/karasumaru/configuration.nix
      ];
    };
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/mac/configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            user = "ichlebemietfreiindeinemapfel";
          };
        }
      ];
    };
  };
}

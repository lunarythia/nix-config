{
	description = "meowx";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
	};

	outputs = { self, nixpkgs, home-manager, nix-darwin, nix-homebrew, ... }@inputs: {
		nixosConfigurations.meowx = nixpkgs.lib.nixosSystem {
			system = "x86_64-linux";
			modules = [
				./hosts/nixos/configuration.nix
				{
					nixpkgs.config.allowUnfree = true;
				}
				home-manager.nixosModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
						users.lunarythia = import ./users/lunarythia/home.nix;
						backupFileExtension = "backup";
					};
				}
        inputs.sops-nix.nixosModules.sops
			];
		};

    darwinConfigurations.macnix = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./hosts/macnix/configuration.nix
        {
					nixpkgs.config.allowUnfree = true;
        }
        nix-homebrew.darwinModules.nix-homebrew
        {
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "amberwing";
            autoMigrate = true;
          };
        }
        
				home-manager.darwinModules.home-manager {
					home-manager = {
						useGlobalPkgs = true;
						useUserPackages = true;
            extraSpecialArgs = { inherit inputs; };
						users.amberwing = import ./users/lunarythia/home-darwin.nix;
						backupFileExtension = "backup";
					};
				}
        inputs.sops-nix.darwinModules.sops
      ];
    };
	};
}

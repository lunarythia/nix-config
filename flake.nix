{
	description = "meowx";

	inputs = {
		nixpkgs.url = "nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager/master";
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { self, nixpkgs, home-manager, ... }@inputs: {
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
						users.lunarythia = import ./users/lunarythia/home.nix;
						backupFileExtension = "backup";
					};
				}
			];
		};
	};
}

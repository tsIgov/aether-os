{
	description = "AetherOS";

	inputs = {
		nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
		elephant.url = "github:abenz1267/elephant";
		walker = {
			url = "github:abenz1267/walker";
			inputs.elephant.follows = "elephant";
		};
		superfile.url = "github:yorukot/superfile";
	};

	outputs = inputs:
	let
		lib = inputs.nixpkgs.lib;
		pkgs = import inputs.nixpkgs {
			system = "x86_64-linux";
			config.allowUnfree = true;
			overlays = import ./overlays lib "nixpkgs";
		};
		aetherLib = import ./lib { inherit pkgs lib; };
		aetherPkgs = import ./packages { inherit pkgs lib aetherLib; };
		aetherThemes = import ./themes { inherit pkgs lib aetherLib aetherPkgs; };

		aether = {
			pkgs = aetherPkgs;
			lib = aetherLib;
			themes = aetherThemes;
			inputs = inputs;
		};

		home-module = { ... }: {
			imports = [ inputs.home-manager.nixosModules.home-manager ];
			home-manager = {
				useGlobalPkgs = true;
				useUserPackages = false;
			};
		};
	in
	{
		lib = aetherLib;
		aetherConfig = import ./default.nix { inherit aether pkgs home-module; };
		templates = rec {
			installer = {
				path = ./templates/installer;
				description = "A trivial template that does nothing much.";
			};
		};
	};
}

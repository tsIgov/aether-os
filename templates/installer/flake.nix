{
	description = "AetherOS";

	inputs = {
		aether.url = "github:tsIgov/aether-desktop-environment";
		user-pkgs.url = "github:nixos/nixpkgs/nixos-unstable";
	};

	outputs = { aether, ... }@inputs:
	let
		inherit (aether.lib.moduleUtils) listModulesRecursively;

		system = "x86_64-linux";
		importArguments = { inherit system; config.allowUnfree = true; };
	in
		aether.aetherConfig {
			specialArgs = {
				user-pkgs = import inputs.bax importArguments;
			};
			modules = [
				./hardware-configuration.nix
				./file-system-configuration.nix
			]
			++ (listModulesRecursively ./modules)
			++ (listModulesRecursively ./config);
		};
}

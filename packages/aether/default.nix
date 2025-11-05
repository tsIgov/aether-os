{ aetherDrv, nixos-rebuild }:

aetherDrv {
	name = "aether";
	version = "1.0";

	srcs = [
		./src
		./make
	];

	runtimeDeps = [ nixos-rebuild ];
}

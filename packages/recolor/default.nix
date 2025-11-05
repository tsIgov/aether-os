{
	aetherDrv,
	python3,

	color-scheme ? null
}:
let
	python = (python3.withPackages (pp: [ pp.tqdm pp.pillow ]));
	palette = import ./createPalette.nix color-scheme;
in

aetherDrv {
	name = "aether-recolor";
	version = "1.0";

	srcs = [
		./src
		./lib/basic_colormath.tar.gz
		./lib/color_manager.tar.gz
		./make
	];

	buildArgs = [
		palette
	];

	runtimeDeps = [ python ];
}

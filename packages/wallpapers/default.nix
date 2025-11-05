{
	aetherDrv,
	inkscape,

	background-color ? null,
	foreground-color ? null
}:

aetherDrv {
	name = "aether-wallpapers";
	version = "1.0";

	buildDeps = [ inkscape ];

	srcs = [
		./make
		./images
	];

	buildArgs = [
		background-color
		foreground-color
	];
}

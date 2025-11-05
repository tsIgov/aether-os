{
	stdenv,
	inkscape,

	background-color ? null,
	foreground-color ? null
}:

stdenv.mkDerivation {
	pname = "aether-wallpapers";
	version = "1.0";

	buildInputs = [ inkscape ];

	srcs = [ ./src ];
	sourceRoot = "./src";

	buildFlags = [
		"BACKGROUND_COLOR=${background-color}"
		"FOREGROUND_COLOR=${foreground-color}"
	];
}

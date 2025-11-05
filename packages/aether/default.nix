{ stdenv }:

stdenv.mkDerivation {
	pname = "aether";
	version = "1.0";

	srcs = [ ./src	];
	sourceRoot = "./src";

	dontBuild = true;
}

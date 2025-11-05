{
	lib,
	stdenv,

	gum,
	iputils,
	util-linux,
	parted,
	cryptsetup,

	makeWrapper
}:

stdenv.mkDerivation rec {
	pname = "aether-install";
	version = "1.0";

	buildInputs = [
		gum
		iputils # ping
		util-linux # cfdisk
		parted
		cryptsetup
	];

	nativeBuildInputs = [
		makeWrapper
	];

	dontBuild = true;

	srcs = [ ./src	];
	sourceRoot = "./src";

	postInstall = ''
		wrapProgram $out/bin/aether-install \
			--prefix PATH : ${lib.makeBinPath buildInputs}
	'';
}

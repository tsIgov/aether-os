{
	stdenv,
	lib,

	python3,

	makeWrapper,

	color-scheme ? null
}:
let
	python = (python3.withPackages (pp: [ pp.tqdm pp.pillow ]));
	palette = import ./createPalette.nix color-scheme;
in

stdenv.mkDerivation rec {
	pname = "aether-recolor";
	version = "1.0";

	buildInputs = [ python ];
	nativeBuildInputs = [ makeWrapper ];

	srcs = [
		./src
		./lib/basic_colormath.tar.gz
		./lib/color_manager.tar.gz
	];
	sourceRoot = "./src";

	buildPhase = ''
		echo -e '${palette}' > palette.json
	'';

	postInstall = ''
		wrapProgram $out/bin/aether-recolor \
			--prefix PATH : ${lib.makeBinPath buildInputs }
	'';

}

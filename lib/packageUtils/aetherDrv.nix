{ pkgs, lib }:
{ name, version, srcs, buildDeps ? [], runtimeDeps ? [], dontFixup ? false, buildArgs ? [], installArgs ? [] }:
let
	convertArgs = arr: builtins.concatStringsSep " " (map (x: "'${toString x}'") arr);
in
pkgs.stdenv.mkDerivation {
	pname = name;
	inherit version;

	buildInputs = runtimeDeps;
	nativeBuildInputs = buildDeps ++ [ pkgs.makeWrapper ];

	inherit srcs;
	sourceRoot = ".";

	buildPhase = ''
		runHook preBuild

		if [ -f ./make/build.sh ]; then
			bash ./make/build.sh ${convertArgs buildArgs}
		fi

   		runHook postBuild
	'';

	installPhase = ''
		mkdir -p $out

		runHook preInstall

		if [ -f ./make/install.sh ]; then
			bash ./make/install.sh ${convertArgs installArgs}
		fi

		runHook postInstall
	'';

	postInstall = ''
		if [ -d $out/bin/ ]; then
			wrapProgram $out/bin/* \
				--prefix PATH : ${lib.makeBinPath runtimeDeps}
		fi
	'';

	inherit dontFixup;
}

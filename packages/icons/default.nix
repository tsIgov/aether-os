{
	stdenv,
	lib,

	catppuccin-papirus-folders,
	recolor,

	color-scheme ? null
}:
let
	icons = (catppuccin-papirus-folders.override
		{
			flavor = "mocha";
			accent = "mauve";
		}).overrideAttrs (oldAttrs: { dontFixup = true; });

	recolorOvrd = recolor.override { inherit color-scheme; };
in

stdenv.mkDerivation {
	pname = "aether-icons";
	version = "1.0";

	nativeBuildInputs = [ recolorOvrd ];

	srcs = [
		"${icons}/share"
	];
	sourceRoot = ".";

	buildPhase = ''
		${recolorOvrd}/bin/aether-recolor share/icons/Papirus $TMPDIR/output
	'';

	installPhase = ''
		mkdir -p $out/share/icons
		cp -r $TMPDIR/output $out/share/icons/aether-icons
	'';

	dontFixup = true;
}

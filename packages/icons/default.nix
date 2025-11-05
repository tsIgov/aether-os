{
	aetherDrv,

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

aetherDrv {
	name = "aether-icons";
	version = "1.0";

	buildDeps = [ recolorOvrd ];

	srcs = [
		"${icons}/share"
		./make
	];

	dontFixup = true;
}

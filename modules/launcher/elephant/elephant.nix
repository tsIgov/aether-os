{ aether, ... }:
let
	elephantPkg = aether.inputs.elephant.packages."x86_64-linux".default;
in
{
	hm = {
		home.file.".config/elephant/providers".source = "${elephantPkg}/lib/elephant/providers";

		home.file.".config/elephant/menus".source = ./menus;

		home.file.".config/elephant/desktopapplications.toml".source = ./desktopapplications.toml;
		home.file.".config/elephant/clipboard.toml".source = ./clipboard.toml;
	};
}

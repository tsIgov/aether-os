{ config, aether, pkgs, ... }:
let
	palette = config.aether.theme.color-scheme;
in
{
	hm = {
		home = {
			packages = [
				aether.pkgs.kitty-grab
			];

			file = {
				".config/kitty/kitty_grab".source = "${aether.pkgs.kitty-grab}/share/kitty/kitty_grab";
				".config/kitty/grab.conf".source = pkgs.replaceVars ./grab.conf {
					inherit (palette)
						primary background2;
				};
			};
		};
	};
}

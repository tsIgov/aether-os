{ aether, ... }:
{
	aether = {
		connectivity.hostname = "aether-os";
		user.username = "aether";
		user.description = "aether";
		theme = { inherit (aether.themes.catppuccin { flavor = "mocha"; }) color-scheme fonts plymouth; };
	};
}

{ config, lib, ... }:
let
	inherit (lib) mkOption;
	inherit (lib.types) listOf str submodule;

	cfg = config.aether.launcher.websearch;

	mapEngineToEntry = engine: ''
		[[entries]]
		name = "${engine.name}"
		url = "${engine.url}"
		icon = "${engine.icon}"
	'';

	tomlEntries = builtins.concatStringsSep "\n\n" (builtins.map (eng: mapEngineToEntry eng) cfg.engines);
in
{
	options.aether.launcher.websearch.engines = mkOption {
		default = [];
		description = "Websearch engines to be used in the launcher websearch functionality.";
		type = listOf (submodule {
			options = {
				name = mkOption { type = str; example = "Google "; };
				url = mkOption { type = str; description = "The url to open. Use %TERM% as a placeholder for the query."; example = "https://www.google.com/search?q=%TERM%"; };
				icon = mkOption { type = str; default="internet-web-browser"; example = "google"; };
			};
		});
	};

	config = {
		hm = {
			home.file.".config/elephant/websearch.toml".text = ''
				history = false
				history_when_empty = false
				engines_as_actions = false
				command = "xdg-open"

				${tomlEntries}
			'';
		};
	};
}

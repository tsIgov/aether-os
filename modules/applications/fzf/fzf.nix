{ pkgs, config, ... }:
let
	palette = config.aether.theme.color-scheme;
in
{
	environment = {
		systemPackages = with pkgs; [
			fzf
			fd
		];

		shellAliases = {
			ff = "fzf | wl-copy";
			cdf = "cd $(fd --type directory | fzf)";
		};

		variables = {
			FZF_DEFAULT_OPTS_FILE = "/etc/fzf/fzf-config";
		};

		etc = {
			"fzf/fzf-config" = {
				source = pkgs.replaceVars ./fzf-config {
					inherit (palette) foreground0 foreground2 background0 primary secondary;
				};
				mode = "0444";
			};

			"aether/applications/scripts/fzf-preview.sh" = {
				source = ./fzf-preview.sh;
				mode = "0555";
			};
		};
	};
}

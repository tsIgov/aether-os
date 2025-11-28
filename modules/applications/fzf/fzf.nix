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
			fe = "fzf --exact | wl-copy";
		};

		variables = {
			FZF_DEFAULT_OPTS_FILE = "/etc/fzf/fzf-config";
			# FZF_DEFAULT_OPTS = "--border --height ~20 --layout reverse --exact --style full --input-label ' Input ' --header-label ' File Type ' --color 'border:#${palette.primary}' --color 'preview-border:#${palette.foreground0},preview-label:#${palette.foreground0}' --color 'list-border:#${palette.primary},list-label:#${palette.primary}' --color 'input-border:#${palette.secondary},input-label:#${palette.secondary}' --color 'header-border:#${palette.foreground2},header-label:#${palette.foreground2}' --color 'fg:#${palette.foreground0},hl:#${palette.secondary},current-fg:#${palette.primary},current-bg:#${palette.background0},input-fg:#${palette.foreground0},pointer:#${palette.background0},marker:#${palette.primary},spinner:#${palette.primary},info:#${palette.foreground2},prompt:#${palette.foreground0}' --color 'preview-fg:#${palette.foreground0}'";
		};

		etc = {
			"fzf/fzf-config" = {
				source = pkgs.replaceVars ./fzf-config {
					inherit (palette) foreground0 foreground2 background0 primary secondary;
				};
				mode = "0444";
			};
		};
	};
}

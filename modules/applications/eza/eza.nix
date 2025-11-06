{ pkgs, config, ... }:
let
	palette = config.aether.theme.color-scheme;
in
{
	environment = {
		systemPackages = with pkgs; [
			eza
		];
		shellAliases = {
			ls = "eza";
			ll = "eza --long";
			lt = "eza --long --tree --level=2 ";
		};
	};

	hm = {
		home.file.".config/eza/theme.yml".source = pkgs.replaceVars ./theme.yml {
			inherit (palette)
				primary secondary error warning
				foreground0 foreground1 foreground2
				green yellow orange cyan red;
		};
	};
}

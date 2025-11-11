{ pkgs, config, aether, ... }:
let
	palette = config.aether.theme.color-scheme;
	micro-gui = pkgs.writeShellScriptBin "micro-gui" ''
		${pkgs.kitty}/bin/kitty --class micro micro "$@"
	'';
in
{
	programs.nano.enable = false;
	environment = {
		systemPackages = with pkgs; [
			micro
			micro-gui
			aether.inputs.superfile.packages."x86_64-linux".default
		];
		variables = {
			EDITOR = "micro";
			VISUAL = "micro-gui";
			MICRO_TRUECOLOR = 1;
		};
	};

	hm = {
		home.file = {
			".config/micro/colorschemes/aether.micro".source = pkgs.replaceVars ./color-scheme.micro {
				inherit (palette)
					foreground0 foreground1 foreground2
					background2
					surface0
					primary secondary warning error
					cyan blue violet yellow orange green red magenta;
			};
			".config/micro/settings.json".source = ./settings.json;
			".config/micro/bindings.json".source = ./bindings.json;
		};

		xdg = {
			desktopEntries.micro = {
				name = "Micro";
				genericName = "Text Editor";
				icon = "micro";
				exec= "micro-gui %F";
				terminal = false;
				type = "Application";
				categories = [ "TextEditor" "Utility" ];
			};
		};

	};
}

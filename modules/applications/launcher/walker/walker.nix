{ aether, config, pkgs, ... }:
{
	nix.settings = {
		substituters = [
			"https://walker.cachix.org"
			"https://walker-git.cachix.org"
		];
		trusted-public-keys = [
			"walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="
			"walker-git.cachix.org-1:vmC0ocfPWh0S/vRAQGtChuiZBTAe4wiKDeyyXM0/7pM="
		];
	};

	hm = {
		programs.walker = {
  			enable = true;
			runAsService = true;

			config = {
				close_when_open = true;
				click_to_close = true;
				disable_mouse = false;
				exact_search_prefix = "'";
				force_keyboard_focus = true;
				global_argument_delimiter = "#";
				selection_wrap = false;
				hide_quick_activation = true;
				resume_last_query = false;
				theme = "aether";

				shell = {
					anchor_bottom = true;
					anchor_left = true;
					anchor_right = true;
					anchor_top = true;
				};

				keybinds = {
					close = [ "Escape" ];
					next = [ "Down" ];
					previous = [ "Up" ];
					quick_activate = [];
					toggle_exact = [];
					resume_last_query = [];
					page_down = ["Page_Down"];
					page_up = ["Page_Up"];
				};

				providers = {
					default = [ "desktopapplications" "calc" ];
					empty = [ "desktopapplications" ];
					max_results = 50;
					prefixes = [
						{ provider = "desktopapplications"; prefix = "$"; }
						{ provider = "clipboard"; prefix = "!"; }
						{ provider = "websearch"; prefix = "@"; }
						{ provider = "symbols"; prefix = ":"; }
						{ provider = "unicode"; prefix = ";"; }
						{ provider = "calc"; prefix = "="; }
						{ provider = "menus:aether"; prefix = "/"; }
					];
					actions = {
						fallback = [
							{ action = "menus:open"; label = "open"; after = "Nothing"; }
							{ action = "menus:default"; label = "run"; after = "Close"; }
							{ action = "menus:parent"; label = "back"; bind = "Escape"; after = "Nothing"; }
							{ action = "erase_history"; label = "clear hist"; bind = "ctrl h"; after = "AsyncReload"; }
						];

						calc = [
							{ action = "copy"; default = true; bind = "Return"; }
							{ action = "delete"; bind = "ctrl d"; after = "AsyncReload"; }
							{ action = "save"; bind = "ctrl s"; after = "AsyncClearReload"; }
						];

						desktopapplications = [
							{ action = "start"; default = true; bind = "Return"; }
							{ action = "start:keep"; unset = true; }
							{ action = "new_instance"; unset = true; }
							{ action = "new_instance:keep"; unset = true; }
							{ action = "pin"; unset = true; }
							{ action = "unpin"; unset = true; }
							{ action = "pinup"; unset = true; }
							{ action = "pindown"; unset = true; }
						];

						"menus:performance" = [
							{ action = "run"; default = true; bind = "Return"; }
							{ action = "test-action"; bind = "ctrl t"; after = "AsyncReload"; }
						];
					};
				};
			};

			themes = {
				"aether" = {
					style = builtins.readFile (pkgs.replaceVars ./style.css {
						inherit (config.aether.theme.color-scheme)
							overlay
							background1 background2
							foreground0 foreground1
							primary;
					});

					layouts = {
						"layout" = builtins.readFile (./layout.xml);
						"item_calc" = builtins.readFile (./item-iconless.xml);
					};
				};
			};
		};


		wayland.windowManager.hyprland = {
			settings = {
				layerrule = [
					"noanim, walker"
				];
			};
		};

		imports = [ aether.inputs.walker.homeManagerModules.default ];
	};
}

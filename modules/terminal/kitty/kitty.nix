{ config, aether, ... }:
let
	palette = config.aether.theme.color-scheme;
in
{
	hm = {
		programs.kitty = {
			enable = true;
			font = {
				name = config.aether.theme.fonts.mono;
				size = config.aether.theme.fonts.size;
			};

			settings = {
				shell = "fish";
				strip_trailing_spaces = "smart";
				window_padding_width = 25;
				confirm_os_window_close = 0;
				enable_audio_bell = "no";

				cursor_shape = "beam";
				cursor_shape_unfocused = "unchanged";
				cursor_blink_interval = 1;

				foreground ="#${palette.foreground0}";
				background = "#${palette.background0}";
				selection_foreground = "#${palette.background2}";
				selection_background = "#${palette.primary}";

				cursor = "#${palette.primary}";
				cursor_text_color = "#${palette.background2}";

				url_color = "#${palette.secondary}";
				url_style = "straight";

				mark1_foreground = "#${palette.background2}";
				mark1_background = "#${palette.primary}";
				mark2_foreground = "#${palette.background2}";
				mark2_background = "#${palette.secondary}";
				mark3_foreground = "#${palette.background2}";
				mark3_background = "#${palette.secondary}";

				# The 16 terminal colors

				# black
				color0 = "#${palette.surface0}";
				color8 = "#${palette.surface0}";

				# red
				color1 = "#${palette.red}";
				color9 = "#${palette.red}";

				# green
				color2 = "#${palette.green}";
				color10 = "#${palette.green}";

				# yellow
				color3 = "#${palette.yellow}";
				color11 = "#${palette.yellow}";

				# blue
				color4 = "#${palette.blue}";
				color12 = "#${palette.blue}";

				# magenta
				color5 = "#${palette.magenta}";
				color13 = "#${palette.magenta}";

				# cyan
				color6 = "#${palette.cyan}";
				color14 = "#${palette.cyan}";

				# white
				color7 = "#${palette.foreground0}";
				color15 = "#${palette.foreground0}";

				clear_all_shortcuts = "yes";
			};

			keybindings = {
				"ctrl+c" = "copy_and_clear_or_interrupt";
				"ctrl+v" = "paste_from_clipboard";

				"ctrl+up" = "scroll_line_up";
				"ctrl+down" = "scroll_line_down";
				"page_up" = "scroll_page_up";
				"page_down" = "scroll_page_down";
				"ctrl+home" = "scroll_home";
				"ctrl+end" = "scroll_end";
				"alt+up" = "scroll_to_prompt -1";
				"alt+down" = "scroll_to_prompt 1";

				"ctrl+shift+equal" = "change_font_size all +1.0";
				"ctrl+shift+plus" = "change_font_size all +1.0";
				"ctrl+shift+kp_add" = "change_font_size all +1.0";
				"ctrl+shift+minus" = "change_font_size all -1.0";
				"ctrl+shift+kp_subtract" = "change_font_size all -1.0";
				"ctrl+shift+backslash" = "signal_child SIGTERM";
				"ctrl+shift+c" = "signal_child SIGINT";
				"ctrl+shift+z" = "signal_child SIGSTP";
				"ctrl+shift+k" = "signal_child SIGKILL";
				"ctrl+shift+s" = "kitten kitty_grab/grab.py";
				"alt+s" = "kitten kitty_grab/grab.py";
			};
		};
	};
}

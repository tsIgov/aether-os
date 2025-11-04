{ config, ... }:
let
	palette = config.aether.theme.color-scheme;
in
{
	hm = {
		wayland.windowManager.hyprland.settings = {
			general = {
				border_size = 1;
				gaps_in = 5;
				gaps_out = 10;
				gaps_workspaces = 0;

				"col.active_border" = "rgb(${palette.primary})";
				"col.inactive_border" = "rgb(${palette.surface2})";
				"col.nogroup_border" = "rgb(${palette.surface2})";
				"col.nogroup_border_active" = "rgb(${palette.primary})";
			};

			decoration = {
				rounding = 2;
				blur.enabled = false;
				shadow.enabled = false;
			};

			animations = {
				enabled = true;
				first_launch_animation = false;
				bezier = [
					"myBezier, 0.05, 0.9, 0.1, 1.05"
				];
				animation = [
					"windows, 1, 7, myBezier, popin"
					"border, 1, 7, default"
					"fade, 1, 7, myBezier"
					"workspaces, 1, 10, myBezier, fade"
					"specialWorkspace, 1, 10, myBezier, fade"
				];
			};

			group = {
				"col.border_active" = "rgb(${palette.secondary})";
				"col.border_inactive" = "rgb(${palette.surface2})";
				"col.border_locked_active" = "rgb(${palette.primary})";
				"col.border_locked_inactive" = "rgb(${palette.surface2})";

				groupbar = {
					enabled = true;
					render_titles = false;
					height = 1;
					keep_upper_gap = false;

					"col.active" = "rgb(${palette.secondary})";
					"col.inactive" = "rgb(${palette.surface2})";
					"col.locked_active" = "rgb(${palette.primary})";
					"col.locked_inactive" = "rgb(${palette.surface2})";
				};
			};

			misc = {
				disable_hyprland_logo = true;
				disable_splash_rendering = true;
				force_default_wallpaper = 0;
				background_color = "rgb(${palette.background0})";
			};
		};
	};
}

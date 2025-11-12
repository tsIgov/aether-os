{ pkgs, ... }:
{
	hm = {
		wayland.windowManager.hyprland = {
			extraConfig = ''
				bindr = SUPER, SUPER_L, exec, walker
				bind = SUPER, Slash, exec, walker -m menus:aether
				bind = SUPER, V, exec, walker -m clipboard
				bind = CTRL ALT, Delete, exec, walker -m menus:power

				bind = SUPER, T, exec, ${pkgs.kitty}/bin/kitty
				bind = SUPER, E, exec, ${pkgs.nemo}/bin/nemo

				bind = SUPER SHIFT, C, exec, hyprpicker -a
			'';
		};
	};
}

{ pkgs, ... }:
{
	environment.systemPackages = with pkgs; [
		wl-clipboard
		wl-clip-persist
	];

	hm = {
		wayland.windowManager.hyprland = {
			settings.exec-once = [
				"${pkgs.wl-clip-persist}/bin/wl-clip-persist --clipboard regular"
			];
		};
	};
}

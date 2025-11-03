{ ... }:
{
	imports = [
		../../modules/boot/bootloader.nix
		../../modules/boot/logging.nix

		../../modules/connectivity/network.nix

		../../modules/system/system.nix
		../../modules/system/user.nix
		../../modules/system/version.nix

		../../modules/terminal/fish.nix
		../../modules/terminal/newt.nix
		../../modules/terminal/starship.nix
		../../modules/terminal/tty.nix

		../../modules/theme/color-scheme.nix
		../../modules/theme/fonts.nix
		../../modules/theme/plymouth.nix
	];

}

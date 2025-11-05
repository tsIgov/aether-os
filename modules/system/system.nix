{ pkgs, config, lib, aether, ... }:
let
	username = config.aether.user.username;
in
{
	system.stateVersion = "24.11";
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	programs.nix-ld.enable = true; # Allows dynamic linking

	environment.systemPackages = with pkgs; [

		(aether.pkgs.aether)
	];

	imports = [
		(lib.mkAliasOptionModule ["hm"] ["home-manager" "users" username])
	];

	system.tools = {
		nixos-rebuild.enable = false;
		nixos-version.enable = false;
		nixos-option.enable = false;
		nixos-install.enable = false;
		nixos-generate-config.enable = false;
		nixos-enter.enable = false;
		nixos-build-vms.enable = false;
	};

	boot.enableContainers = false;
	documentation.nixos.enable = false;

	hm = {
		programs.home-manager.enable = true;
		news.display = "silent";

		home = {
			username = username;
			homeDirectory = "/home/${username}";
			stateVersion = "24.05";
		};
	};
}

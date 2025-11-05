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

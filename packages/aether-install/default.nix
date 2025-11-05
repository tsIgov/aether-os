{ aetherDrv, pkgs }:
aetherDrv {
	name = "aether-install";
	version = "1.0";

	runtimeDeps = with pkgs; [
		gum
		iputils # ping
		util-linux # cfdisk
		parted
		cryptsetup
		nixos-install-tools
	];

	srcs = [
		./src
		./make
	];
}

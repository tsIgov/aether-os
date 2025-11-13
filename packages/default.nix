{ pkgs, lib, aetherLib }:
let
	aetherDrv = aetherLib.packageUtils.aetherDrv;
in
rec {
	aether = pkgs.callPackage ./aether { inherit aetherDrv; };
	aether-install = pkgs.callPackage ./aether-install { inherit aetherDrv; };
	kitty-grab = pkgs.callPackage ./aether-grab { inherit aetherDrv; };
	recolor = pkgs.callPackage ./recolor { inherit aetherDrv; };
	icons = pkgs.callPackage ./icons { inherit aetherDrv recolor; };
	wallpapers = pkgs.callPackage ./wallpapers { inherit aetherDrv; };
}

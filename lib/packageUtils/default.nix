{ pkgs, lib }:
rec {
	aetherDrv = import ./aetherDrv.nix { inherit pkgs lib; };
}

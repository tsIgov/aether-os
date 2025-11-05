{ pkgs, lib }:
{
	colorUtils = import ./colorUtils { inherit lib; };
	moduleUtils = import ./moduleUtils { inherit lib; };
	packageUtils = import ./packageUtils { inherit pkgs lib; };
}

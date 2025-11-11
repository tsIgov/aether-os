{ pkgs, aether, ... }:
{
	environment = {
		systemPackages = with pkgs; [
			aether.inputs.superfile.packages."x86_64-linux".default
		];
	};
}

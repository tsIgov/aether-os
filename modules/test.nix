{ pkgs, config, aether, ... }:
{
	environment = {
		systemPackages = [
			aether.pkgs.aether-install
		];
	};


}

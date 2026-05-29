{ ... }:
{
	aether.display = {
		profiles = [
			{
				# Docked
				monitors = [
					{
						name = "DP-[0-9]";
						enabled = true;
						scale = "auto";
						resolution = "preferred";
						position = "auto";
						extraArgs = "";
					}
					{
						name = "eDP-1";
						enabled = false;
					}
				];
			}
		];
	};
}

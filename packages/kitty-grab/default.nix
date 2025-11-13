{
	aetherDrv,
	fetchFromGitHub
}:
aetherDrv {
	name = "kitty-grab";
	version = "969e363";

	srcs = [
		(fetchFromGitHub {
			owner = "yurikhan";
			repo = "kitty_grab";
			rev = "969e363295b48f62fdcbf29987c77ac222109c41";
			sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
		})
	];

	dontFixup = true;
}

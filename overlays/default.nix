lib:
let
	files = lib.filesystem.listFilesRecursive ./.;
	nixFiles = builtins.filter (n: lib.strings.hasSuffix ".nix" (toString n)) files;
	withoutSelf = builtins.filter (n: n != ./default.nix) nixFiles;
	result = builtins.map (n: import n) withoutSelf;
in
	result

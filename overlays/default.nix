lib: dir:
let
	files = lib.filesystem.listFilesRecursive (./. + "/${dir}");
	nixFiles = builtins.filter (n: lib.strings.hasSuffix ".nix" (toString n)) files;
	result = builtins.map (n: import n) nixFiles;
in
	result

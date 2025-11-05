set -e

showHelp() {
	echo "Usage: $0 SRC DEST"
}

parseArguments() {
	if [[ $# -eq 0 ]]; then
		showHelp
		exit 0
	fi

	for arg in "$@"
	do
		case "$arg" in
		-h|--help)
			showHelp
			exit 0
		;;
		-*)
			echo "Invalid argument: $arg"
			exit 1
		;;
		*)
			if [[ $DEST ]]; then
				echo "Too many arguments."
				exit 1
			fi

			if [[ ! $SRC ]]; then
				SRC=$arg
				continue
			fi

			if [[ ! $DEST ]]; then
				DEST=$arg
				continue
			fi
		;;
		esac
	done
}

checkInputs() {
	if [[ ! -d "$SRC" ]]; then
		echo "Source doesn't exist."
		exit 1
	fi

	if [[ -d "$DEST" ]]; then
		echo "Destination directory already exists."
		exit 1
	fi
}

parseArguments $@
checkInputs

SCRIPT=$(realpath -s "$0")
SCRIPTPATH=$(dirname "$SCRIPT")
SRC=$(realpath $SRC)
DEST=$(realpath $DEST)
NAME=$(basename $DEST)
DIR=$(dirname $DEST)
PALETTE=$SCRIPTPATH/../palette.json

cd $SCRIPTPATH/../lib

mkdir -p $DIR

python3 -c "
from color_manager import utils
src = \"$SRC\"
dest = \"$DIR\"
name = \"$NAME\"
palette = \"$PALETTE\"
utils.recolor(src, dest, name, palette)
"

#! /bin/sh
set -euo pipefail

AETHER_CONFIG_LOCATION="$HOME/.config/aether"

show_help() {
    cat << EOF
Usage: $0 [COMMAND] [ARGS...]

Commands:
  apply 		       Applies the current configuration
  update [ARGS...]     Updates AetherOS and applies the current configuration
  gc				   Deletes all old profile and runs the garbage collector and the store optimiser

Arguments for update:
  all                  Also updates all other inputs
  [input1 input2 ...]  Also updates the specified inputs

Options:
  -h, --help           Show this help message
EOF
}



update() {
	sudo -v

	if [[ $# -eq 0 ]]; then
		inputs="aether"
	elif [[ "$1" == "all" ]]; then
		inputs=""
	else
		inputs=("$@")
	fi

	cd "$AETHER_CONFIG_LOCATION"
	nix flake update "${inputs[@]}"
	sudo nixos-rebuild switch --flake .#aether-os  --quiet
}



apply() {
	sudo -v

	cd "$AETHER_CONFIG_LOCATION"
	sudo nixos-rebuild switch --flake .#aether-os --quiet
}



garbageCollect() {
	nix-collect-garbage --delete-old
	nix-store --optimise
}



if [[ $# -eq 0 ]]; then
    show_help
    exit 0
fi

case "$1" in
    -h|--help)
        show_help
        ;;
    update)
        shift
        update "$@"
        ;;
    apply)
        shift
        apply "$@"
        ;;
	gc)
        shift
        garbageCollect "$@"
        ;;
    *)
        echo "Error: Unknown command '$1'"
        show_help
        exit 1
        ;;
esac


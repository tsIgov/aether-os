#!/bin/bash
strict_mode() {
    set -T # inherit DEBUG and RETURN trap for functions
    set -C # prevent file overwrite by > &> <>
    set -E # inherit -e
    set -e # exit immediately on errors
    set -u # exit on not assigned variables
    set -o pipefail # exit on pipe failure
}
strict_mode

keep_sudo() {
	sudo -v

	# Keep the sudo timestamp updated until the script finishes
	# (runs in the background)
	while true; do
		sudo -n true
		sleep 60
		kill -0 "$$" || exit
	done 2>/dev/null &
}
keep_sudo

SCRIPT_PATH="$(readlink -f "$0")"
SCRIPT_DIR="$(dirname "$SCRIPT_PATH")"

config_gum() {
	export GUM_CHOOSE_SHOW_HELP=0
	export GUM_TABLE_SHOW_HELP=0
	export GUM_CONFIRM_SHOW_HELP=0
	export GUM_INPUT_SHOW_HELP=0

	export GUM_TABLE_HIDE_COUNT=1
	export GUM_TABLE_SELECTED_FOREGROUND="#a6e3a1"

	export GUM_CONFIRM_PROMPT_FOREGROUND="#cdd6f4"
	export GUM_CONFIRM_SELECTED_FOREGROUND="#11111b"
	export GUM_CONFIRM_SELECTED_BACKGROUND="#cba6f7"
	export GUM_CONFIRM_UNSELECTED_FOREGROUND="#cdd6f4"
	export GUM_CONFIRM_UNSELECTED_BACKGROUND="#313244"

	export GUM_CHOOSE_CURSOR_FOREGROUND="#a6e3a1"
	export GUM_CHOOSE_ITEM_FOREGROUND="#cdd6f4"
	export GUM_CHOOSE_SELECTED_FOREGROUND="#a6e3a1"

	export GUM_INPUT_PLACEHOLDER_FOREGROUND="#a6adc8"
	export GUM_INPUT_PROMPT_FOREGROUND="#cdd6f4"
	export GUM_INPUT_CURSOR_FOREGROUND="#cdd6f4"
}
config_gum



reset_values() {
	INTERNET=""

	DISK=""
	START_SECTOR=""
	FREE_SPACE_MIB=""
	SECTORS_PER_MIB=""
	BOOT_SIZE=""
	SWAP_SIZE=""
	ROOT_SIZE=""
	ENCRYPTION_PASSWORD=""

	HOSTNAME=""
	ROOT_PASSWORD=""
	USERNAME=""
	USER_PASSWORD=""

	check_internet_connection
}



# ================================
# Helpers
# ================================

min_int() {
	echo $(( $1 < $2 ? $1 : $2 ))
}

max_int() {
	echo $(( $1 > $2 ? $1 : $2 ))
}

mask_password() {
	if [[ $# -gt 0 ]]; then
		echo "*******"
	else
		echo ""
	fi
}

screen() {
	local accent_color='\033[0;35m'
	local error_color='\033[0;31m'
	local reset_color='\033[0m'

	clear > /dev/tty
	echo -e "${accent_color}<<< $1 >>>${reset_color}" > /dev/tty

	if [[ $# -gt 1 && -n "$2" ]]; then
		echo -e "$2" > /dev/tty
	fi

	if [[ $# -gt 2 && -n "$3" ]]; then
		echo -e "${error_color}$3${reset_color}" > /dev/tty
	fi

	echo > /dev/tty
}

error_message() {
	local error_color='\033[0;31m'
	local reset_color='\033[0m'
	echo -e "${error_color}$1${reset_color}\n" > /dev/tty
}

check_internet_connection() {
	local site_to_ping="github.com"
	if ! ping -c 1 -W 10 "$site_to_ping" &>/dev/null; then
		INTERNET="Not connected"
		return
	fi

	INTERNET="Connected"
}

get_sectors_per_mib() {
	local bytes_per_sector
	bytes_per_sector=$(cat /sys/block/$(basename "$1")/queue/hw_sector_size)
	awk -v bps=$bytes_per_sector 'BEGIN {printf "%d", 1024 * 1024 / bps}'
}

get_ram_mib() {
	awk '/MemTotal/ {printf "%d", $2 / 1024}' /proc/meminfo
}

choose_allocation_size() {
	local result title
	local min_size_mib default_size_mib max_size_mib

	local invalid_number_message="Invalid value (must be a valid number in the specified range)."

	min_size_mib=$1
	default_size_mib=$2
	max_size_mib=$3
	title="$4"

	default_size_mib=$(min_int $default_size_mib $max_size_mib)
	default_size_mib=$(max_int $default_size_mib $min_size_mib)

	local subtitle="Choose a size between ${min_size_mib} MiB and ${max_size_mib} MiB (write the number only)."

	if [[ $min_size_mib -gt $max_size_mib ]]; then
		screen "$title" "" "The remaining unallocated space is less than the required minimum of $min_size_mib MiB."
		result=$(gum choose "Back" --header "" || true)
		return
	fi

	screen "$title" "$subtitle"

	while true; do
		result=$(gum input --placeholder "Size in MiB" --value "$default_size_mib" || true )

		local number_regex='^[1-9]?[0-9]*$'
		if [[ $result == "" ]]; then
			return
		fi

		if [[ ! $result =~ $number_regex ]]; then
			screen "$title" "$subtitle" "$invalid_number_message"
			continue
		fi

		if awk "BEGIN {exit !($result < $min_size_mib || $result > $max_size_mib)}"; then
			screen "$title" "$subtitle" "$invalid_number_message"
			continue
		fi

		echo "$result"
		return
	done
}

remaining_space() {
	local boot=$BOOT_SIZE swap=$SWAP_SIZE root=$ROOT_SIZE

	if [[ $boot == "" ]]; then boot=0; fi
	if [[ $swap == "" ]]; then swap=0; fi
	if [[ $root == "" ]]; then root=0; fi

	case "$1" in
		"boot") boot=0;;
		"swap") swap=0;;
		"root") root=0;;
	esac

	local result
	result=$(( $FREE_SPACE_MIB - $boot - $swap - $root ))

	result=$(max_int 0 $result)
	echo $result
}

is_valid_hostname() {
	local hostname="$1"

	# Must not exceed 253 characters
	[[ ${#hostname} -le 253 ]] || return 1

	# Regex for valid hostname
	local regex='^([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)(\.([a-zA-Z0-9]([a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?))*$'

	[[ $hostname =~ $regex ]]
}

is_valid_username() {
	local username="$1"

	# Length check (1-32 chars)
	if [[ ${#username} -lt 1 || ${#username} -gt 32 ]]; then
		return 1
	fi

	# Pattern check
	if [[ "$username" =~ ^[a-z_][a-z0-9_-]*$ ]]; then
		return 0
	else
		return 1
	fi
}

choose_password() {
	local title="$1" subtitle="$2"
	local password="" password_repeat="" option

	while [[ -z "$password" || -z "$password_repeat" || "$password" != "$password_repeat" ]]; do
		screen "$title" "$subtitle"

		password=$(gum input --password --placeholder "Type your password..." || true)
		if [[ $password == "" ]]; then
			return
		fi

		password_repeat=$(gum input --password --placeholder "Repeat your password..." || true)
		if [[ $password_repeat == "" ]]; then
			return
		fi

		if [[ "$password" == "$password_repeat" ]]; then
			echo "$password"
			return
		fi

		screen "$title" "$subtitle" "Passwords do not match."
		option=$(gum choose "Try again" --header "" || true)
		case "$option" in
			"Try again") continue;;
			*) return;;
		esac
	done
}

run() {
	local scriptName=$1
	shift 1
	sudo sh -c "source \"$SCRIPT_DIR/../lib/$scriptName\" \"\$@\"" _ "$@"
}



# ================================
# Menu
# ================================

menu() {
	local devider="---------------,," arrow="->"
	local option=""

	while true; do

		screen "Welcome to AetherOS" "This wizzard will guide you through the installation.\nSet your preferences and choose the install button."

		local options=",,\n" allocated_space_label="" swap_size_label="" root_size_label="" boot_size_label=""

		if [[ $DISK != "" ]]; then
			allocated_space_label="/dev/${DISK} (${FREE_SPACE_MIB} MiB)"
		fi
		if [[ $BOOT_SIZE != "" ]]; then
			boot_size_label="${BOOT_SIZE} MiB"
		fi
		if [[ $SWAP_SIZE != "" ]]; then
			swap_size_label="${SWAP_SIZE} MiB"
		fi
		if [[ $ROOT_SIZE != "" ]]; then
			root_size_label="${ROOT_SIZE} MiB"
		fi


		options="${options}Internet,${arrow},${INTERNET}\n"
		options="${options}${devider}\n"

		options="${options}Allocated space,${arrow},${allocated_space_label}\n"
		if [[ $DISK != "" ]]; then
			options="${options}Boot size,${arrow},${boot_size_label}\n"
			options="${options}Swap size,${arrow},${swap_size_label}\n"
			options="${options}Root size,${arrow},${root_size_label}\n"
			options="${options}Encryption password,${arrow},$(mask_password $ENCRYPTION_PASSWORD)\n"
		fi
		options="${options}${devider}\n"

		options="${options}Hostname,${arrow},${HOSTNAME}\n"
		options="${options}Root password,${arrow},$(mask_password $ROOT_PASSWORD)\n"
		options="${options}Username,${arrow},${USERNAME}\n"
		options="${options}User password,${arrow},$(mask_password $USER_PASSWORD)\n"
		options="${options}${devider}\n"

		options="${options}Install,,\n"
		options="${options}Quit,,\n"

		option=$(echo -e "$options" | gum table -r 1)
		case "$option" in
			"Internet") internet;;
			"Allocated space") allocated_space;;
			"Boot size") boot_size;;
			"Swap size") swap_size;;
			"Root size") root_size;;
			"Encryption password") encryption_password;;
			"Root password") root_password;;
			"User password") user_password;;
			"Hostname") host_name;;
			"Username") user_name;;
			"Install") install;;
			"Quit") quit;;
		esac
	done
}

internet() {
	nmtui
	check_internet_connection
}

manage_disks() {
	local title="Manage disks" subtitle="Select a disk to manage." divider="---------------"
	local disks disk option
	while true; do
		screen "$title" "$subtitle"

		disks=$(lsblk -ndAo NAME,SIZE,MODEL)

		option=$(echo -e "$disks\n$divider\nContinue" | gum choose --header "" || true)
		case "$option" in
			"") return;;
			"Continue") return;;
			"$divider") ;;
			*)
				disk=$(echo $option | awk '{print $1;}')
				disk="/dev/$disk"
				sudo cfdisk $disk
			;;
		esac
	done
}

allocated_space() {
	local divider="---------------" option

	while true; do
		screen "Allocate space" "Choose an unallocated space to use for AetherOS"
		local csv=$(echo -e "Device,Start sector,End sector,Size (MiB)")
		local devices=$(lsblk -ndAo NAME)

		for device in $devices; do
			local data sectors_per_mib
			sectors_per_mib=$(get_sectors_per_mib $device)
			data=$(sudo parted -m "/dev/$device" unit s print free | awk -F: -v dv="$device" -v spm="$sectors_per_mib" '
				$1 ~ /^[0-9]+$/ && $5 == "free;" {
					start = substr($2, 1, length($2)-1)
					start = int((start + spm - 1) / spm) * spm

					end = substr($3, 1, length($3)-1)
					end = int(end / spm) * spm

					size = (end - start + 1) / spm
					if (size >= 10) {
						printf "%s,%d,%d,%d\n", dv, start, end, size
					}
				}')
			csv="$csv\n$data"
		done

		csv="$csv\n$divider,,,\nManage disks,,,\nBack,,,"
		option=$(echo -e "$csv" | gum table || true)
		case "$option" in
			"") return;;
			"Back,,,") return;;
			"Manage disks,,,") manage_disks;;
			"$divider,,,") ;;
			*)
				DISK=$(echo "$option" | awk -F',' '{print $1}')
				START_SECTOR=$(echo "$option" | awk -F',' '{print $2}')
				FREE_SPACE_MIB=$(echo "$option" | awk -F',' '{print $4}')
				SECTORS_PER_MIB=$(get_sectors_per_mib $DISK)
				BOOT_SIZE=""
				SWAP_SIZE=""
				ROOT_SIZE=""
				ENCRYPTION_PASSWORD=""
				return
			;;
		esac
	done
}

boot_size() {
	local title="Boot size" result

	local max_size_mib min_size_mib=256 default_size_mib=512
	max_size_mib=$(remaining_space "boot")

	result=$(choose_allocation_size $min_size_mib $default_size_mib $max_size_mib "$title")
	if [[ $result != "" ]]; then
		BOOT_SIZE=$result
	fi
}

swap_size() {
	local title="Swap size" result

	local max_size_mib min_size_mib=0 ram_mib
	max_size_mib=$(remaining_space "swap")
	ram_mib=$(get_ram_mib)

	result=$(choose_allocation_size $min_size_mib $ram_mib $max_size_mib "$title")
	if [[ $result != "" ]]; then
		SWAP_SIZE=$result
	fi
}

root_size() {
	local title="Root size" result

	local max_size_mib min_size_mib=102400
	max_size_mib=$(remaining_space "root")

	result=$(choose_allocation_size $min_size_mib $max_size_mib $max_size_mib "$title")
	if [[ $result != "" ]]; then
		ROOT_SIZE=$result
	fi
}

encryption_password() {
	ENCRYPTION_PASSWORD=$(choose_password "Encryption password" "Choose a password that will be used for disk encryption.")
}

root_password() {
	ROOT_PASSWORD=$(choose_password "Root password" "Choose a password for the root user.")
}

user_password() {
	USER_PASSWORD=$(choose_password "User password" "Choose a password for your user.")
}

host_name() {
	local title="Hostname" subtitle="Pick a name for the machine." result
	screen "$title" "$subtitle"

	while true; do
		result=$(gum input --placeholder="Hostname" --value="$HOSTNAME" || true)

		if [[ $result == "" ]]; then
			return
		fi

		if ( ! is_valid_hostname "$result" ); then
			screen "$title" "$subtitle" "Invalid hostname"
			continue
		fi

		HOSTNAME="$result"
		return
	done
}

user_name() {
	local title="Username" subtitle="Must be between 1 and 32 characters long. Must start with a lowercase letter or an underscore. The rest may only include lowercase letters, digits, underscores, or dashes."
	local result
	screen "$title" "$subtitle"

	while true; do
		result=$(gum input --placeholder="Username" --value="$USERNAME" || true)

		if [[ $result == "" ]]; then
			return
		fi

		if ( ! is_valid_username "$result" ); then
			screen "$title" "$subtitle" "Invalid username"
			continue
		fi

		USERNAME="$result"
		return
	done
}

quit() {
	local result
	clear
	if $(gum confirm "Are you sure you want to exit the installer?" --default=no); then
		exit
	fi
}



# ================================
# Install
# ================================
check_config() {

	local title="Installing AetherOS"

	if [[ -z "$DISK" || -z "$START_SECTOR" || -z "$SECTORS_PER_MIB" || -z "$BOOT_SIZE" || -z "$SWAP_SIZE" || -z "$ROOT_SIZE" || -z "$ENCRYPTION_PASSWORD" || -z "$HOSTNAME" || -z "$ROOT_PASSWORD" || -z "$USERNAME" || -z "$USER_PASSWORD"  ]]; then
		screen "$title" "" "Some of the options are not set."
		gum choose "Back" --header "" || true
		return 1
	fi

	check_internet_connection
	if [[ "$INTERNET" == "Not connected" ]]; then
		screen "$title" "" "Not connected to the internet."
		gum choose "Back" --header "" || true
		return 1
	fi
}

install() {
	local option

	if (! check_config); then
		return
	fi

	if (! $(gum confirm "We are ready to install AetherOS." --affirmative="Continue" --negative="Back")); then
		return
	fi

	screen "Preparing disk"
	if ! run "partition-disk.sh" $DISK $START_SECTOR $ROOT_SIZE $SWAP_SIZE $BOOT_SIZE $SECTORS_PER_MIB $ENCRYPTION_PASSWORD; then
		error_message "Instalation failed."
		gum choose "Start over" --header "" || true
		reset_values
		return
	fi

	screen "Preparing installer"
	if ! run "prepare-config.sh" "$HOSTNAME" "$ROOT_PASSWORD" "$USERNAME" "$USER_PASSWORD" "$SWAP_SIZE"; then
		error_message "Instalation failed."
		gum choose "Start over" --header "" || true
		reset_values
		return
	fi

	while true; do
		screen "Installing AetherOS"
		if ! run "install-os.sh"; then
			error_message "Instalation failed."
			option=$(echo -e "Retry\nStart over" | gum choose --header "" || true)
			case "$option" in
				"Try again") continue;;
				*)
					reset_values
					return
				;;
			esac
		fi
		break
	done

	screen "Post-install configuration"
	run "post-install.sh" "$USERNAME" | true

	screen "Installation successful" "Reboot now?"
	option=$(echo -e "Reboot\nExit" | gum choose --header "" || true)
	case "$option" in
		"Reboot")
			clear
			reboot
			exit
		;;
		*)
			clear
			exit
		;;
	esac

}

# ================================
# Main
# ================================

reset_values
menu



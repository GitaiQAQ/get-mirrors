#!/bin/sh
set -e

# This script is meant for quick & easy install via:
#   $ curl -fsSL get_mirrors.gitai.me | sh
#
# NOTE: Make sure to verify the contents of the script
#       you downloaded matches the contents of install.sh
#       located at https://github.com/GitaiQAQ/get-mirrors
#       before executing.
#
# Git commit from https://github.com/GitaiQAQ/get-mirrorswhen
# the script was uploaded (Should only be modified by upload job):

SCRIPT_COMMIT_SHA=UNKNOWN

host_sort(){
    	echo $1 | while read x ; do echo `ping -c 3 $x | grep loss | awk '{print $10,x}' x=$x` & done | sort -n -k2
}

best_host(){
	if command_exists pinfg; then
		host_sort $1 | awk '{print $2}' | head -n 1
	else
		echo $1 | head -n 1
	fi
}

get_machine() {
	echo `uname -m`
}

get_distribution() {
	lsb_dist=""
	# Every system that we officially support has /etc/os-release
	if [ -r /etc/os-release ]; then
		lsb_dist="$(. /etc/os-release && echo "$ID")"
	fi
	# Returning an empty string here should be alright since the
	# case statements don't act unless you provide an actual value
	echo "$lsb_dist"
}

get_dist_version() {
	lsb_dist=$1
	case "$lsb_dist" in
		ubuntu)
			if command_exists lsb_release; then
				dist_version="$(lsb_release --codename | cut -f2)"
			fi
			if [ -z "$dist_version" ] && [ -r /etc/lsb-release ]; then
				dist_version="$(. /etc/lsb-release && echo "$DISTRIB_CODENAME")"
			fi
		;;
		debian|raspbian)
			dist_version="$(sed 's/\/.*//' /etc/debian_version | sed 's/\..*//')"
			case "$dist_version" in
				9)
					dist_version="stretch"
				;;
				8)
					dist_version="jessie"
				;;
				7)
					dist_version="wheezy"
				;;
			esac
		;;

		centos)
			if [ -z "$dist_version" ] && [ -r /etc/os-release ]; then
				dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
			fi
		;;

		rhel|ol|sles)
			ee_notice "$lsb_dist"
			exit 1
			;;

		*)
			if command_exists lsb_release; then
				dist_version="$(lsb_release --release | cut -f2)"
			fi
			if [ -z "$dist_version" ] && [ -r /etc/os-release ]; then
				dist_version="$(. /etc/os-release && echo "$VERSION_ID")"
			fi
		;;

	esac
	echo $dist_version
}

command_exists() {
	command -v "$@" > /dev/null 2>&1
}

get_user() {
	echo "$(id -un 2>/dev/null || true)"
}

root_check() {
	user=get_user
	# DEBUG
	# sh_c='echo'
	sh_c='sh -c'
	if [ "$user" != 'root' ]; then
		if command_exists sudo; then
			sh_c='sudo -E sh -c'
		elif command_exists su; then
			sh_c='su -c'
		else
			cat >&2 <<-'EOF'
			Error: this installer needs the ability to run commands as root.
			We are unable to find either "sudo" or "su" available to make this happen.
			EOF
			exit 1
		fi
	fi
	echo $sh_c
}

do_install() {
	echo "# Executing mirrors auto-config script, commit: $SCRIPT_COMMIT_SHA"

	sh_c=`root_check`

	# perform some very rudimentary platform detection
	lsb_dist=$( get_distribution )
	lsb_dist="$(echo "$lsb_dist" | tr '[:upper:]' '[:lower:]')"

	dist_version=`get_dist_version $lsb_dist`

	machine=`get_machine`

	echo "# System info: $lsb_dist:$dist_version-$machine"

	echo "# Advanced Package Tool(apt)"
	if command_exists apt; then
		host=`best_host $($sh_c ./apt/get_mirrors.sh)`
		echo "# While use mirror $host"
		$sh_c "cd ./apt && ./install.sh $lsb_dist $dist_version $machine $host"
	fi

	echo "# The Python Package Index (PyPI)"
	if command_exists pip; then
		host=`best_host $($sh_c ./pipy/get_mirrors.sh)`
		echo "# While use mirror $host"
		$sh_c "cd ./pipy && ./install.sh $lsb_dist $dist_version $machine $host"
	fi

	echo "# Node Package Manager (npm)"
	if command_exists npm; then
		host=`best_host $($sh_c ./npm/get_mirrors.sh)`
		echo "# While use mirror $host"
		sh -c "cd ./npm && ./install.sh $lsb_dist $dist_version $machine $host"
	fi

	echo "# Docker Registry (docker)"
	if command_exists docker; then
		if [ ! -z $REGISTRY_MIRRORS ];then
			host=$REGISTRY_MIRRORS
			echo "# While use mirror $host"
			sh -c "cd ./docker && ./set_mirror.sh $REGISTRY_MIRRORS"
		else
			echo "Set \$REGISTRY_MIRRORS in env for docker"
		fi

	fi
}

# wrapped up in a function so that we have some protection against only getting
# half the file during "curl | sh"
do_install

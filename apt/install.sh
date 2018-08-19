SUPPORT_MAP=`ls . | grep ".list"`

do_install() {
	lsb_dist=$1
	dist_version=$2
	machine=$3
	mirror=$4

	id=$mirror-$lsb_dist-$dist_version

	sourcesfile="./$id.list"

	if ! echo "$SUPPORT_MAP" | grep $id >/dev/null; then
		cat >&2 <<-'EOF'
		Either your platform is not easily detectable or is not supported by this
		installer script.
		Please visit the following URL for more detailed installation instructions:
		https://github.con/GitaiQAQ/get-mirrors/
		EOF
		exit 1
	fi

	if [ -f $sourcesfile ];then 
		if [ ! -f /etc/apt/sources.list ];then 
			mkdir -p /etc/apt/sources.list
		fi
		cp $sourcesfile /etc/apt/sources.list
	fi
}

do_install $1 $2 $3 $4 $5
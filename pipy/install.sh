SUPPORT_MAP=`ls | grep ".conf"`

do_install() {
	mirror=$4

	id=$mirror

	sourcesfile="./$id.conf"

	if ! echo "$SUPPORT_MAP" | grep $id >/dev/null; then
		echo $id
		cat >&2 <<-'EOF'
		Either your platform is not easily detectable or is not supported by this
		installer script.
		Please visit the following URL for more detailed installation instructions:
		https://github.con/GitaiQAQ/get-mirrors/
		EOF
		exit 1
	fi

	if [ -f $sourcesfile ];then 
		if [ ! -f ~/.pip ];then 
			mkdir -p ~/.pip
		fi
		cp $sourcesfile ~/.pip/pip.conf
	fi
}

do_install $1 $2 $3 $4 $5
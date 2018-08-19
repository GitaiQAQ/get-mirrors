SUPPORT_MAP="
https://registry.npmjs.org
https://registry.npm.taobao.org
https://r.cnpmjs.org
"

do_install() {
	mirror=$4

	id=$mirror

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

	npm config set registry https://$id

	if [ "$id"=="registry.npm.taobao.org" ];then 
		npm install -g cnpm --registry=https://registry.npm.taobao.org
	fi
}

do_install $1 $2 $3 $4 $5
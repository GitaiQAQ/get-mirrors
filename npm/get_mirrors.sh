hosts="
registry.npmjs.org
registry.npm.taobao.org
r.cnpmjs.org
"

do_get() {
	lsb_dist=$1
	dist_version=$2
	machine=$3
	
	echo $hosts
}

do_get $1 $2 $3

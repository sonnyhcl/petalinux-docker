#!/usr/bin/env bash
if [ $# != 2 ]; then
	echo "Usage:       $0 [tftp_dir] [version]"
	echo
	echo "for example: $0 `pwd` 2018.2"
	exit 1;
fi

docker_context=`pwd`
tftp_dir=$1
version=$2

cd ${tftp_dir}
if [ -f "petalinux-v${version}-final-installer.run" ]; then
	echo [${tftp_dir}/petalinux-v${version}-final-installer.run] exists
	python3 -m http.server &
	server_pid=$!
	echo PID [${server_pid}] http.server starting...
	echo
else  
	echo make sure [petalinux-v${version}-final-installer.run] exists in the [${tftp_dir}]
	echo
	kill ${server_pid}
	exit 1
fi

cd ${docker_context}
if [ -f "Dockerfile" ]; then
	echo Dockerfile exists in [${docker_context}]
	echo
	timestamp=`date +"%Y-%m-%d-%H-%M-%S"`
	docker build -t sonnyhcl/petalinux:$timestamp .
	docker tag sonnyhcl/petalinux:$timestamp sonnyhcl/petalinux:latest
else
	echo make sure Dockerfile exists in [${docker_context}]
	echo
fi

kill ${server_pid}

echo "-------------------------------------------------------------------"
echo "                        finish building                            "
echo "-------------------------------------------------------------------"
docker images | grep petalinux

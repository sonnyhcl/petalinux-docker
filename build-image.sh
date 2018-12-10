#!/usr/bin/env bash
if [ $# != 2 ]; then
echo
echo "USAGE: $0 {installer_dir} {petalinux_version}"
echo "for example: $0 `pwd` 2018.2"
echo
exit 1;
fi

installer_dir=$1
petalinux_version=$2

echo 
echo Make sure you have already put {petalinux-v$2-final-installer.run} in the {$1}
echo

docker_context=`pwd`
echo
echo "Start to build petalinux tools docker image ..."
echo

cd $installer_dir
python3 -m http.server &
server_pid=$!
echo 
echo PID ${server_pid}
echo http.server starting...

cd $docker_context
installer_ip=`ifconfig docker0 | grep 'inet\s' | awk '{print $2}' | cut -c 6-`
echo $installer_ip

docker build -t petalinux:$2 .

kill $server_pid

echo "---------------"
echo "finish building"
docker images | grep petalinux
echo "---------------"

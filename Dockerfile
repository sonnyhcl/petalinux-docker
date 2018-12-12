FROM  	ubuntu:16.04

LABEL 	maintainer="sonnyhcl@163.com"

ENV 	DEBIAN_FRONTEND=noninteractive
ENV 	LC_ALL=en_US.UTF-8 
ENV 	LANG=en_US.UTF-8 
ENV 	LANGUAGE=en_US.UTF-8 
ENV 	TZ=Asia/Shanghai

ARG 	installer_url="172.17.0.1:8000"
ARG 	version=2018.2
ARG 	user=plnx

RUN 	adduser --disabled-password --gecos '' $user

RUN 	mkdir -p /opt/petalinux /home/$user/project

RUN 	chown -R $user:$user /opt/petalinux /home/$user/project

# using local mirror to speed up
# COPY /etc/apt/sources.list /etc/apt/sources.list
COPY 	sources.list /etc/apt/sources.list

RUN 	dpkg --add-architecture i386 	&& \
    	apt-get update -y 		&& \
    	apt-get clean all 		&& \
    	apt-get install -y -qq iputils-ping sudo rsync apt-utils x11-utils

# Required tools and libraries of Petalinux.
# See in: ug1144-petalinux-tools-reference-guide, 2018.2
RUN 	apt-get install -y -qq --no-install-recommends \
	tofrodos iproute2 gawk xvfb gcc-4.8 wget build-essential \
	checkinstall libreadline-gplv2-dev libncursesw5-dev libssl-dev \
	libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev git make \
	net-tools libncurses5-dev zlib1g-dev libssl-dev flex bison \
	libselinux1 gnupg diffstat chrpath socat xterm autoconf libtool \
	tar unzip texinfo gcc-multilib libsdl1.2-dev libglib2.0-dev \
	screen pax gzip language-pack-en libtool-bin cpio lib32z1 lsb-release \
	zlib1g:i386 vim-common libgtk2.0-dev libstdc++6:i386 libc6:i386 \
	expect
	# Using expect to install Petalinux automatically.

# bash is PetaLinux recommended shell
RUN 	ln -fs /bin/bash /bin/sh    

RUN 	echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER 	$user

RUN 	echo "source /opt/petalinux/settings.sh" >> ~/.bashrc

WORKDIR /home/$user/project

COPY 	noninteractive-install.sh .

RUN 	wget -q ${installer_url}/petalinux-v${version}-final-installer.run  	&& \
	chmod a+x petalinux-v${version}-final-installer.run                 	&& \
	./noninteractive-install.sh /opt/petalinux ${version}                   && \
    	rm -rf petalinux-v${version}-final-installer.run			&& \
	rm noninteractive-install.sh *log


FROM  ubuntu:16.04
LABEL maintainer="sonnyhcl@163.com"

ENV LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 TZ=Asia/Shanghai

ARG installer_url="172.17.0.1:8000"
ARG version=2018.2
ARG user=plnx

RUN mkdir -p /opt/petalinux/${version}

RUN adduser --disabled-password --gecos '' $user

RUN echo $user:$user | chpasswd

RUN chown -R $user:$user /opt/petalinux

# using local mirror to speed up
# COPY /etc/apt/sources.list /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list

RUN dpkg --add-architecture i386 &&\
    apt update -y && apt clean all &&\
    apt install -y iputils-ping sudo locales-all

# Required tools and libraries of Petalinux.
# See in: ug1144-petalinux-tools-reference-guide, 2018.2
RUN apt install -y --no-install-recommends \
	tofrodos iproute2 gawk xvfb gcc-4.8 wget build-essential checkinstall libreadline-gplv2-dev \
	libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev git make net-tools libncurses5-dev \
	zlib1g-dev libssl-dev flex bison libselinux1 gnupg diffstat chrpath socat xterm autoconf libtool tar unzip texinfo \
	gcc-multilib libsdl1.2-dev libglib2.0-dev screen pax gzip language-pack-en libtool-bin cpio lib32z1 lsb-release zlib1g:i386 \
	vim-common libgtk2.0-dev libstdc++6:i386 libc6:i386 \
	expect
	# Using expect to install Petalinux automatically.

USER $user

WORKDIR /opt/petalinux

COPY ./auto-install.sh .

RUN wget ${installer_url}/petalinux-v${version}-final-installer.run  && \
    chmod a+x petalinux-v${version}-final-installer.run              && \
    ./auto-install.sh /opt/petalinux/${version} ${version}           && \
    rm -rf petalinux-v${version}-final-installer.run

USER root

RUN ln -fs /bin/bash /bin/sh    # bash is PetaLinux recommended shell

RUN apt install rsync -y

RUN echo "$user ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER $user

RUN echo "source /opt/petalinux/${version}/settings.sh" >> ~/.bashrc

WORKDIR /home/$user


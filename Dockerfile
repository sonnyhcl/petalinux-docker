FROM  ubuntu:16.04
LABEL maintainer="sonnyhcl@163.com"

ARG install_dir=/opt
ARG installer_url="172.17.0.1:8000"
ARG petalinux_version=2018.2

ENV PETALINUX_VER=${petalinux_version}
ENV PETALINUX=${install_dir}/petalinux/${petalinux_version} 
ENV PATH="${PETALINUX}/tools/linux-i386/arm-xilinx-gnueabi/bin:\
${PETALINUX}/tools/linux-i386/arm-xilinx-linux-gnueabi/bin:\
${PETALINUX}/tools/linux-i386/microblaze-xilinx-elf/bin:\
${PETALINUX}/tools/linux-i386/microblazeel-xilinx-linux-gnu/bin:\
${PETALINUX}/tools/linux-i386/petalinux/bin:\
${PETALINUX}/tools/common/petalinux/bin:\
${PATH}"

RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y --no-install-recommends \
# Required tools and libraries of Petalinux.
# See in: ug1144-petalinux-tools-reference-guide 
	tofrodos iproute2 gawk xvfb gcc-4.8 wget build-essential checkinstall libreadline-gplv2-dev \
	libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev git make net-tools libncurses5-dev \
	tftpd zlib1g-dev libssl-dev flex bison libselinux1 gnupg diffstat chrpath socat xterm autoconf libtool tar unzip texinfo \
	gcc-multilib libsdl1.2-dev libglib2.0-dev screen pax gzip language-pack-en libtool-bin cpio lib32z1 lsb-release zlib1g:i386 \
	vim-common libgtk2.0-dev libstdc++6:i386 libc6:i386 \
# Using expect to install Petalinux automatically.
    expect              \
&& rm -rf /var/lib/apt/lists/* /tmp/* \
&& ln -fs gcc-4.8 /usr/bin/gcc        \
&& ln -fs gcc-ar-4.8 /usr/bin/gcc-ar  \
&& ln -fs gcc-nm-4.8 /usr/bin/gcc-nm  \
&& ln -fs gcc-ranlib-4.8 /usr/bin/gcc-ranlib

# Using local mirror to speed up
# COPY /etc/apt/sources.list /etc/apt/sources.list
COPY sources.list /etc/apt/sources.list

# There are two methods to get petalinux installer in:
# 1. Using COPY instruction, but it will significantly increase the size of image.
#    In this way, you should place installer to context which is sent to docker daemon.
# 2. Getting installer via network, but it need a server exit. If there is not a web
#    address to host it, a simple http server can be set up locally using python.
# You should choose one of them.
# = 1. =============================================================================
# COPY ./petalinux-v2014.4-final-installer.run .
# RUN  chmod a+x petalinux-v2014.4-final-installer.run \
#      && ./auto-install.sh $install_dir
# = 2. =============================================================================
WORKDIR ${installer_dir}
COPY ./auto-install.sh .
RUN wget  ${installer_url}/petalinux-v${petalinux_version}-final-installer.run && \
    chmod a+x petalinux-v${petalinux_version}-final-installer.run             && \
    chmod a+x auto-install.sh                                                 && \
    ./auto-install.sh ${install_dir} ${petalinux_version}                     && \
    rm -rf petalinux-v${petalinux_version}-final-installer.run
# ==================================================================================

RUN ln -fs /bin/bash /bin/sh    # bash is PetaLinux recommended shell

RUN adduser --disabled-password --gecos '' plnx
USER plnx
WORKDIR /home/plnx


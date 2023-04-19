FROM ubuntu:22.04
ENV DEBIAN_FRONTEND noninteractive
ENV OPTEE_VERSION 3.20.0
RUN apt-get update && \
    apt-get -y install \
	adb \
	acpica-tools \
	autoconf \
	automake \
	bc \
	bison \
	build-essential \
	ccache \
	cscope \
	curl \
	device-tree-compiler \
	expect \
	fastboot \
	flex \
	ftp-upload \
	gdisk \
	libattr1-dev \
	libcap-dev \
	libcap-ng-dev \
	libfdt-dev \
	libftdi-dev \
	libglib2.0-dev \
	libgmp3-dev \
	libhidapi-dev \
	libmpc-dev \
	libncurses5-dev \
	libpixman-1-dev \
	libssl-dev \
	libtool \
	make \
	mtools \
	netcat \
	ninja-build \
	python3-cryptography \
	python3-pip \
	python3-pyelftools \
	python3-serial \
	python-is-python3 \
	rsync \
	unzip \
	uuid-dev \
	xdg-utils \
	xterm \
	xz-utils \
	zlib1g-dev \
	# extra for Docker only \
	cpio \
	git \
	wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl https://storage.googleapis.com/git-repo-downloads/repo > /bin/repo
RUN chmod a+x /bin/repo

RUN mkdir repo && \
    cd repo && \
    repo init -u https://github.com/OP-TEE/manifest.git -m qemu_v8.xml -b $OPTEE_VERSION && \
    repo sync -j`nproc` && \
    cd build && make toolchains -j`nproc`
RUN cd repo/build && make OPTEE_RUST_ENABLE=y CFG_TEE_RAM_VA_SIZE=0x00300000 -j`nproc`
    

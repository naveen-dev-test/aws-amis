#! /usr/bin/env sh

pkg install -y \
    curl \
    git \
    gnupg \
    openjdk11 \
    python3 \
    unzip \
    cmake \
    valgrind \
    doxygen \
    graphviz \
    lcov \
    wget \
    lsof \
    gmake \
    perl5 \
    bash \
    py39-pip

mount -t fdescfs fdesc /dev/fd
mount -t procfs proc /proc

echo 'fdesc             /dev/fd fdescfs rw      0       0' >> /etc/fstab
echo 'proc              /proc   procfs  rw      0       0' >> /etc/fstab

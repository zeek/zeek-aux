FROM opensuse/tumbleweed

RUN zypper refresh \
 && zypper in -y \
    awk \
    cmake \
    diffutils \
    gcc-c++ \
    git \
    gzip \
    libpcap-devel \
    make \
    python3 \
    python3-pip \
    tar \
    which \
  && rm -rf /var/cache/zypp

RUN pip3 install --break-system-packages btest

FROM opensuse/tumbleweed

RUN zypper refresh \
 && zypper in -y \
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

RUN pip install btest

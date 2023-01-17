FROM opensuse/leap:15.4

RUN zypper refresh \
 && zypper in -y \
    cmake \
    gcc10 \
    gcc10-c++ \
    git \
    gzip \
    libpcap-devel \
    make \
    python3 \
    python3-pip \
    tar \
    which \
  && rm -rf /var/cache/zypp

RUN pip3 install btest

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-10 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-10 100

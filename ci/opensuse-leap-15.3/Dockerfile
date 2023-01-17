FROM opensuse/leap:15.3

RUN zypper refresh \
 && zypper in -y \
    cmake \
    gcc9 \
    gcc9-c++ \
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

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-9 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-9 100

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
    python39 \
    python39-devel \
    python39-pip \
    tar \
    which \
  && rm -rf /var/cache/zypp

RUN update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.9 100

RUN pip3 install btest

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-10 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-10 100

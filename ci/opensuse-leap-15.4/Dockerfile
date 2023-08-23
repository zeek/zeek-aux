FROM opensuse/leap:15.4

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20230823

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

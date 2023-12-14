FROM opensuse/leap:15.5

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20231213

RUN zypper refresh \
 && zypper in -y \
    cmake \
    gcc12 \
    gcc12-c++ \
    git \
    gzip \
    libpcap-devel \
    make \
    python311 \
    python311-devel \
    python311-pip \
    tar \
    which \
  && rm -rf /var/cache/zypp

RUN update-alternatives --install /usr/bin/pip3 pip3 /usr/bin/pip3.11 100

RUN pip3 install btest

RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc-12 100
RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++-12 100

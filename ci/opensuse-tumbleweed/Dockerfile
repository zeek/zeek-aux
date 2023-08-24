FROM opensuse/tumbleweed

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20230823

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

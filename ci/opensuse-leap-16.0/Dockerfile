FROM opensuse/leap:16.0

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20250107

RUN zypper refresh \
 && zypper in -y \
    cmake \
    gcc \
    gcc-c++ \
    git \
    gzip \
    libpcap-devel \
    make \
    python313 \
    python313-devel \
    python313-pip \
    tar \
    which \
  && rm -rf /var/cache/zypp

RUN pip3 install btest

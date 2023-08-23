FROM quay.io/centos/centos:stream8

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20230823

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf config-manager --set-enabled powertools

RUN dnf -y update && dnf -y install \
    git \
    cmake3 \
    diffutils \
    gcc-c++ \
    libpcap-devel \
    make \
    python38 \
    python38-devel \
    python38-pip \
  && dnf clean all && rm -rf /var/cache/dnf

RUN pip3 install btest

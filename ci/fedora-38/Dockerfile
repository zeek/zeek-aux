FROM fedora:38

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20230823

RUN dnf -y install \
    cmake \
    diffutils \
    gcc-c++ \
    git \
    libpcap-devel \
    make \
    python3 \
    python3-pip\
  && dnf clean all && rm -rf /var/cache/dnf

RUN pip install btest

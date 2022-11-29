FROM fedora:37

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20221127

RUN dnf -y install \
    git \
    cmake \
    make \
    gcc-c++ \
  && dnf clean all && rm -rf /var/cache/dnf

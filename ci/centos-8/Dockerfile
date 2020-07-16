FROM centos:8

RUN dnf -y update && dnf -y install \
    git \
    cmake3 \
    make \
    gcc-c++ \
  && dnf clean all && rm -rf /var/cache/dnf

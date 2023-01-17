FROM quay.io/centos/centos:stream8

RUN dnf -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
RUN dnf config-manager --set-enabled powertools

RUN dnf -y update && dnf -y install \
    git \
    cmake3 \
    gcc-c++ \
    libpcap-devel \
    make \
    python3 \
    python3-devel \
    python3-pip\
  && dnf clean all && rm -rf /var/cache/dnf

RUN pip3 install btest

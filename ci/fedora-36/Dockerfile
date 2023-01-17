FROM fedora:36

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

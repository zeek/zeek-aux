FROM quay.io/centos/centos:stream9

# dnf config-manager isn't available at first, and
# we need it to install the CRB repo below.
RUN dnf -y install 'dnf-command(config-manager)'

# What used to be powertools is now called "CRB".
# We need it for some of the packages installed below.
# https://docs.fedoraproject.org/en-US/epel/
RUN dnf config-manager --set-enabled crb
RUN dnf -y install \
    https://dl.fedoraproject.org/pub/epel/epel-release-latest-9.noarch.rpm \
    https://dl.fedoraproject.org/pub/epel/epel-next-release-latest-9.noarch.rpm

RUN dnf -y update && dnf -y install \
    cmake3 \
    gcc-c++ \
    git \
    libpcap-devel \
    make \
    procps-ng \
    python3 \
    python3-pip\
  && dnf clean all && rm -rf /var/cache/dnf

RUN pip install btest

FROM centos:7

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20230823

RUN yum -y install \
    epel-release \
  && yum clean all && rm -rf /var/cache/yum

RUN yum -y install \
    centos-release-scl \
  && yum clean all && rm -rf /var/cache/yum

RUN yum -y install \
    devtoolset-7 \
  && yum clean all && rm -rf /var/cache/yum

RUN yum -y install \
    git \
    cmake3 \
    make \
    libpcap-devel \
    rh-python38 \
    rh-python38-devel \
    rh-python38-python-devel \
    rh-python38-pip \
  && yum clean all && rm -rf /var/cache/yum

RUN pip3 install btest

RUN echo 'unset BASH_ENV PROMPT_COMMAND ENV' > /usr/bin/zeek-ci-env && \
    echo 'source /opt/rh/devtoolset-7/enable' >> /usr/bin/zeek-ci-env && \
    echo 'source /opt/rh/rh-python38/enable' >> /usr/bin/zeek-ci-env

ENV BASH_ENV="/usr/bin/zeek-ci-env" \
    ENV="/usr/bin/zeek-ci-env" \
    PROMPT_COMMAND=". /usr/bin/zeek-ci-env"

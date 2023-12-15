FROM debian:12

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20231213

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles"

RUN apt-get update && apt-get -y install \
    cmake \
    g++ \
    git \
    libpcap-dev \
    make \
    python3 \
    python3-pip\
  && apt autoclean \
  && rm -rf /var/lib/apt/lists/*

RUN pip3 install --break-system-packages btest

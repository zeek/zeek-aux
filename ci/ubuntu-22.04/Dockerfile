FROM ubuntu:22.04

# A version field to invalidate Cirrus's build cache when needed, as suggested in
# https://github.com/cirruslabs/cirrus-ci-docs/issues/544#issuecomment-566066822
ENV DOCKERFILE_VERSION 20230823

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles"

RUN apt-get update && apt-get -y install \
    cmake \
    git \
    g++ \
    libpcap-dev \
    make \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

RUN pip install btest

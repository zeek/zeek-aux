FROM ubuntu:22.04

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

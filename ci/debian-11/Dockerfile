FROM debian:11

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

RUN pip3 install btest

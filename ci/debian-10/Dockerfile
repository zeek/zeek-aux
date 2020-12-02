FROM debian:10

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles"

RUN apt-get update && apt-get -y install \
    git \
    cmake \
    make \
    g++ \
  && rm -rf /var/lib/apt/lists/*

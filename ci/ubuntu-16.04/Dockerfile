FROM ubuntu:16.04

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles"

RUN apt-get update && apt-get -y install \
    git \
    cmake \
    make \
    clang-8 \
    libc++-8-dev \
    libc++abi-8-dev \
  && rm -rf /var/lib/apt/lists/*

ENV CC=/usr/bin/clang-8
ENV CXX=/usr/bin/clang++-8
ENV CXXFLAGS=-stdlib=libc++

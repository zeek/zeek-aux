FROM debian:9

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles"

RUN apt-get update && apt-get -y install \
    git \
    cmake \
    make \
    clang-7 \
    libc++-7-dev \
    libc++abi-7-dev \
  && rm -rf /var/lib/apt/lists/*

ENV CC=/usr/bin/clang-7
ENV CXX=/usr/bin/clang++-7
ENV CXXFLAGS=-stdlib=libc++

FROM ubuntu:18.04

ENV DEBIAN_FRONTEND="noninteractive" TZ="America/Los_Angeles"

ENV CMAKE_DIR "/opt/cmake"
ENV CMAKE_VERSION "3.19.1"
ENV PATH "${CMAKE_DIR}/bin:${PATH}"

RUN apt-get update && apt-get -y install \
    curl \
    git \
    g++ \
    libpcap-dev \
    make \
    python3 \
    python3-pip \
  && rm -rf /var/lib/apt/lists/*

# Recent CMake.
RUN mkdir -p "${CMAKE_DIR}" \
  && curl -sSL "https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-Linux-x86_64.tar.gz" | tar xzf - -C "${CMAKE_DIR}" --strip-components 1

RUN pip3 install btest

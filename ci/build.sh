#! /usr/bin/env bash

set -e
set -x

mkdir build
cd build

if command -v cmake3 >/dev/null 2>&1 ; then
    cmake3 ..
else
    cmake ..
fi

make

#!/bin/sh

echo "Preparing macOS environment"
sysctl hw.model hw.machine hw.ncpu hw.physicalcpu hw.logicalcpu
set -e
set -x

brew update
brew upgrade cmake
brew install openssl@3

# Install btest in a venv since under macos pip refuses to install into the
# global prefix since it is explicitly "externally managed".
python3 -mvenv ./btest.venv
# shellcheck disable=SC1091
. ./btest.venv/bin/activate
pip install btest

# Ensure executables installed via pip are available:
# sudo sh -c 'echo "$(python3 -m site --user-base)/bin" >/etc/paths.d/pip'

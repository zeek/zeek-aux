#!/bin/sh

echo "Preparing macOS environment"
sysctl hw.model hw.machine hw.ncpu hw.physicalcpu hw.logicalcpu
set -e
set -x

brew update
brew upgrade cmake
brew install openssl@1.1

# Install btest in a venv since under macos pip refuses to install into the
# global prefix since it is explicitly "externally managed".
python3 -mvenv ./btest.venv
# shellcheck disable=SC1091
. ./btest.venv/bin/activate
pip install btest

# Brew doesn't create the /opt/homebrew/opt/openssl symlink if you install
# openssl@1.1, only with 3.0. Create the symlink if it doesn't exist.
if [ ! -e /opt/homebrew/opt/openssl ]; then
    if [ -d /opt/homebrew/opt/openssl@1.1 ]; then
        ln -s /opt/homebrew/opt/openssl@1.1 /opt/homebrew/opt/openssl
    fi
fi

# Ensure executables installed via pip are available:
# sudo sh -c 'echo "$(python3 -m site --user-base)/bin" >/etc/paths.d/pip'

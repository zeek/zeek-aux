#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
    echo "This script requires a path to a Zeek repo clone as an argument"
    exit 1
fi

ZEEK_PATH=$1
SCRIPT_PATH="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"

ZEEK_CA_SCRIPT=${ZEEK_PATH}/scripts/base/protocols/ssl/mozilla-ca-list.zeek
ZEEK_CT_SCRIPT=${ZEEK_PATH}/scripts/base/protocols/ssl/ct-list.zeek

# Grab the version list from the Mozilla server and pull out the latest one
NSS_RTM_VERSION=$(curl -s https://ftp.mozilla.org/pub/security/nss/releases/ | grep -oE "NSS_\d_\d+_RTM" | sort -V | uniq | tail -1)
NSS_VERSION=$(echo ${NSS_RTM_VERSION} | grep -oE "\d_\d+" | tr "_" ".")

# Get the current version from the Zeek script file to see if we can just
# skip the rest.
CURRENT_NSS_VERSION=$(awk -F' ' '/^# Generated from:/ {print $NF}' ${ZEEK_CA_SCRIPT})

if [ "${NSS_VERSION}" != "${CURRENT_NSS_VERSION}" ]; then
    NSS_TAR_FILE="nss-${NSS_VERSION}.tar.gz"
    NSS_URL="https://ftp.mozilla.org/pub/security/nss/releases/${NSS_RTM_VERSION}/src/${NSS_TAR_FILE}"

    # Grab the tar file for the release found above
    echo "Downloading NSS file from ${NSS_URL}"
    echo
    curl -o "/tmp/${NSS_TAR_FILE}" "${NSS_URL}"

    # Extract just the certdata.txt file from the tarball, strip all of the path off it,
    # and stick it in /tmp.
    CERTDATA_PATH=$(tar -tzf /tmp/${NSS_TAR_FILE} | grep certdata.txt)
    PREFIX_PATH_PARTS=$(echo ${CERTDATA_PATH} | awk -F'/' '{print NF-1}')
    echo
    echo "Extracting certdata.txt from ${NSS_TAR_FILE}"
    tar -xzf /tmp/${NSS_TAR_FILE} -C /tmp/ --strip-components ${PREFIX_PATH_PARTS} ${CERTDATA_PATH}

    # Run the script on it to generate the Zeek output
    echo "Generating mozilla-ca-list.zeek"
    ${SCRIPT_PATH}/gen-mozilla-ca-list.py /tmp/certdata.txt >"${ZEEK_CA_SCRIPT}"

    sed "s/^# Generated from:.*/# Generated from: NSS ${NSS_VERSION}/g" "${ZEEK_CA_SCRIPT}" >/tmp/mozilla-ca-list.zeek
    mv /tmp/mozilla-ca-list.zeek "${ZEEK_CA_SCRIPT}"

    rm /tmp/${NSS_TAR_FILE}
    rm /tmp/certdata.txt
else
    echo "NSS version in mozilla-ca-list.zeek is same as current upstream version, skipping update"
fi

# The CT list script is easier. It downloads the data from Google instead.
echo "Generating ct-list.zeek"
${SCRIPT_PATH}/gen-ct-list.py >${ZEEK_PATH}/scripts/base/protocols/ssl/ct-list.zeek

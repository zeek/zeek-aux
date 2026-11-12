#!/bin/bash

# Generates a set of patch files from a file containing a list of commit hash
# ranges for each.
#
# A diff file example:
#
# b2afe5af5a
# 0a8d435a9e zeek-8.2.2-tunnel-counting.patch
# 49ea9fa764 zeek-8.2.2-max-irc-dcc-send-commands.patch
# 4efe816750 zeek-8.2.2-smb-andx-limits.patch
# 85a96da24e zeek-8.2.2-irc-dcc-field-validation.patch
# c366b206aa zeek-8.2.2-inner-tunnel-l2-fields.patch
#
# A patch file will be generated between each successive commit, ignoring the
# first commit in the list as the base for the first patch.

DIFFS_FILE=$1
OUTPUT_DIR=$2

LAST_COMMIT=""
while IFS= read -r line; do
    COMMIT=$(echo $line | awk '{print $1}')
    FILENAME=$(echo $line | awk '{print $2}')

    if [ -n "${FILENAME}" ]; then
        if [ -n "${LAST_COMMIT}" ]; then
            echo "Gathering diff for commits:"
            git log --oneline ${LAST_COMMIT}..${COMMIT} | tac
            git diff ${LAST_COMMIT}..${COMMIT} -- ':!testing' >${OUTPUT_DIR}/${FILENAME}
            echo "Saved patch to ${FILENAME}"
            echo
        fi
    fi

    LAST_COMMIT=${COMMIT}
done <${DIFFS_FILE}

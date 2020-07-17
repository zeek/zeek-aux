#! /usr/bin/env bash

set -e

sourcedir="$( cd "$( dirname "$0" )" && pwd )"
cd ${sourcedir}

tmpdir=.tmp
prog=./build/zeek-archiver
testnum=0
exit_code=0

function queue_dir
    {
    echo ${tmpdir}/test-${testnum}/queue
    }

function archive_dir
    {
    echo ${tmpdir}/test-${testnum}/archive
    }

function archive_date_dir
    {
    echo ${tmpdir}/test-${testnum}/archive/2020-07-16
    }

function new_test
    {
    testnum=$(( testnum + 1 ))
    echo "--- Test ${testnum}: $1 ---"
    mkdir -p $(queue_dir)
    }

### Setup
rm -rf ${tmpdir}


### Test Case
new_test "Default behavior: compress the log"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__.log
log_out=test.09\:43\:10-09\:43\:10.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v $(queue_dir) $(archive_dir)

if [[ "$(gunzip <$(archive_date_dir)/${log_out}.gz)" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi

### Test Case
new_test "Disable compression"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__.log
log_out=test.09\:43\:10-09\:43\:10.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v --compress="" $(queue_dir) $(archive_dir)

if [[ "$(cat $(archive_date_dir)/${log_out})" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi

### Test Case
new_test "Detect pre-compressed logs"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__.log
log_out=test.09\:43\:10-09\:43\:10.log

echo hello > $(queue_dir)/${log_in}
gzip $(queue_dir)/${log_in}
${prog} -1 -v $(queue_dir) $(archive_dir)

if [[ "$(gunzip <$(archive_date_dir)/${log_out}.gz)" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi

### Test Case
new_test "Custom delimiter"

log_in=test_2020-07-16-09-43-10_2020-07-16-09-43-10_.log
log_out=test.09\:43\:10-09\:43\:10.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v -d _ $(queue_dir) $(archive_dir)

if [[ "$(gunzip <$(archive_date_dir)/${log_out}.gz)" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi

### Test Case
new_test "Custom timestamp format"

log_in=test__2020-07-16_09-43-10__2020-07-16_09-43-10__.log
log_out=test.09\:43\:10-09\:43\:10.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v --time-fmt %Y-%m-%d_%H-%M-%S $(queue_dir) $(archive_dir)

if [[ "$(gunzip <$(archive_date_dir)/${log_out}.gz)" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi

### Finalize
if [[ ${exit_code} -eq 0 ]]; then
    echo "--- All ${testnum} tests passed ---"
    rm -rf ${tmpdir}
fi

exit ${exit_code}

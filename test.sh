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

### Test Case
new_test "Command injection via filenames"

log_in='test;uptime;__2020-07-16-09-43-10__2020-07-16-09-43-10__.log'
log_out='test;uptime;.09:43:10-09:43:10.log'

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v $(queue_dir) $(archive_dir)

if [[ "$(gunzip <$(archive_date_dir)/${log_out}.gz)" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi

### Test Case
#
# Verify the source file still exists and the destination wasn't created
# (or removed) when the compression command fails.
#
new_test "Failing compress command"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__.log
log_out=test.09\:43\:10-09\:43\:10.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v --compress=false,/bin/false $(queue_dir) $(archive_dir)


if [[ ! -e "$(queue_dir)/${log_in}" ]] || [[ -e "$(archive_date_dir)/${log_out}.false" ]] ; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi


### Test Case
new_test "Pass extra parameters to compression"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__.log
log_out=test.09\:43\:10-09\:43\:10.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v --compress 'gz,gzip -9' $(queue_dir) $(archive_dir)

if [[ "$(gunzip <$(archive_date_dir)/${log_out}.gz)" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi


### Test Case
new_test "Metadata part contains log_suffix=logger-test to be used as suffix"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__log_suffix=logger-test__.log
log_out=test.09\:43\:10-09\:43\:10-logger-test.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v $(queue_dir) $(archive_dir)

if [[ "$(gunzip <$(archive_date_dir)/${log_out}.gz)" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi


### Test Case
new_test "Metadata contains log_suffix=logger-test and pid=4711"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__log_suffix=logger-test,pid=4711__.log
log_out=test.09\:43\:10-09\:43\:10-logger-test.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v $(queue_dir) $(archive_dir)

if [[ "$(gunzip <$(archive_date_dir)/${log_out}.gz)" != "hello" ]]; then
    echo "-- Test ${testnum} failed"
    exit_code=1
fi


### Test Case
new_test "Invalid metadata format causes skipping of archival (1)"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__log_suffix,invalid=4711__.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v $(queue_dir) $(archive_dir)

if [[ ! -f "$(queue_dir)/${log_in}" ]]; then
    echo "-- Test ${testnum} failed - ${log_in} was removed"
    exit_code=1
fi


### Test Case
new_test "Invalid metadata format causes skipping of archival (2)"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10__log_suffix=logger-test,__.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v $(queue_dir) $(archive_dir)

if [[ ! -f "$(queue_dir)/${log_in}" ]]; then
    echo "-- Test ${testnum} failed - ${log_in} was removed"
    exit_code=1
fi


### Test Case
new_test "Invalid metadata format causes skipping of archival (3)"

log_in="test__2020-07-16-09-43-10__2020-07-16-09-43-10__ __.log"

echo hello > "$(queue_dir)/${log_in}"
${prog} -1 -v $(queue_dir) $(archive_dir)

if [[ ! -f "$(queue_dir)/${log_in}" ]]; then
    echo "-- Test ${testnum} failed - ${log_in} was removed"
    exit_code=1
fi


### Test Case
new_test "Empty metadata is acceptable"

log_in=test__2020-07-16-09-43-10__2020-07-16-09-43-10____.log
log_out=test.09\:43\:10-09\:43\:10.log

echo hello > $(queue_dir)/${log_in}
${prog} -1 -v $(queue_dir) $(archive_dir)

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

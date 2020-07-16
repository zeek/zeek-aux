# zeek-archiver

A Zeek log archival service.

This tool is derived from
[bro-atomic-rotate](https://github.com/ncsa/bro-atomic-rotate)
and intends to solve the same failings of Zeek's historical log-archival
process: robustness and atomicity.  It's rewritten with two further
requirements in mind:

* Independence from [ZeekControl](https://github.com/zeek/zeekctl).
  It's meant for use in conjunction with the upcoming
  [Zeek Supervisor Framework](https://docs.zeek.org/en/current/frameworks/supervisor.html).
* Independence from Python.

## Build

Dependencies:

* CMake 3.0 or greater
* C++ compiler with C++17 support (GCC 7+ or Clang 4+)

```
$ mkdir build && cd build && cmake .. && make
```

## Install

Assuming you just followed the Build directions above:

```
$ make install
$ cp zeek-archiver.service /etc/systemd/system/
# Modify the ExecStart invocation in service file as needed.
$ systemctl enable zeek-archiver
$ systemctl start zeek-archiver
```

.. -*- mode: rst; -*-
..
.. Version number is filled in automatically.
.. |version| replace:: 0.32-4

======================
Bro Auxiliary Programs
======================

.. contents::

:Version: |version|

Handy auxiliary programs related to the use of the Bro Network Security
Monitor (http://www.bro.org).

Installation
============

Installation is simple and standard::

    ./configure
    make
    make install

adtrace
=======

The "adtrace" utility is used to compute the
network address that compose the internal and extern nets that bro
is monitoring. This program just reads a pcap
(tcpdump) file and writes out the src MAC, dst MAC, src IP, dst
IP for each packet seen in the file.

bro-cut
=======

The "bro-cut" utility reads ASCII Bro logs on standard input
and outputs them with only the specified columns (if no column names
are specified, then all columns are output).  There are also options to
convert the timestamps into human-readable format, as well as whether
or not to include the format header blocks in the output (by default,
they're not included).  Use the "-h" option to see a list of all options.

devel-tools
===========

A set of scripts used commonly for Bro development. Note that none of
these scripts are installed by 'make install'.

extract-conn-by-uid
    Extracts a connection from a trace file based
    on its UID found in Bro's conn.log

gen-mozilla-ca-list.rb
    Generates list of Mozilla SSL root certificates in
    a format readable by Bro.

update-changes
    A script to maintain the CHANGES and VERSION files.

git-show-fastpath
    Show commits to the fastpath branch not yet merged into master.

cpu-bench-with-trace
    Run a number of Bro benchmarks on a trace file.


nftools
=======

The "nfcollector" and "ftwire2bro" utilities are for dealing with Bro's
custom file format for storing NetFlow records.  The "nfcollector" utility
reads NetFlow data from a socket and writes it in Bro's format.  The
"ftwire2bro" utility reads NetFlow "wire" format (e.g., as generated
by a 'flow-export' directive) and writes it in Bro's format.

rst
===

The "rst" utility can be invoked by a Bro script to terminate an
established TCP connection by forging RST tear-down packets.


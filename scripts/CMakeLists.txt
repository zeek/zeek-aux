install(
    PROGRAMS
        ca-create      host-to-addrs  lock_file
        ca-issue       hot-report     mon-report
        bro-logchk.pl  host-grep      ip-grep        mvlog
    DESTINATION
        scripts
)

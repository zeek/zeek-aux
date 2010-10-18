include(CheckStructHasMember)
check_struct_has_member("struct sockaddr_in" sin_len "netinet/in.h" SIN_LEN)

include(CheckFunctionExists)

check_function_exists(sigset HAVE_SIGSET)
check_function_exists(strerror HAVE_STRERROR)

if (HAVE_SIGSET)
    set(SIG_FUNC sigset)
else ()
    set(SIG_FUNC signal)
    check_function_exists(sigaction HAVE_SIGACTION)
endif ()

include(CheckIncludeFiles)

check_include_files(memory.h HAVE_MEMORY_H)
check_include_files(os-proto.h HAVE_OS_PROTO_H)

include(CheckCSourceCompiles)

check_c_source_compiles("
    #include <sys/types.h>
    #include <sys/socket.h>
    extern int socket(int, int, int);
    extern int connect(int, const struct sockaddr *, int);
    extern int send(int, const void *, int, int);
    extern int recvfrom(int, void *, int, int, struct sockaddr *, int *);
    int main() { return 0; }
" DO_SOCK_DECL)
if (DO_SOCK_DECL)
    message(STATUS "socket() and friends need explicit declaration")
endif ()

if (USE_NB_DNS)
    check_c_source_compiles("
        #include <arpa/nameser.h>
        int main() { HEADER *hdr; int d = NS_IN6ADDRSZ; return 0; }"
        HAVE_ASYNC_DNS)

    if (NOT HAVE_ASYNC_DNS)
        if (${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
            check_c_source_compiles("
                #include <arpa/nameser.h>
                #include <arpa/nameser_compat.h>
                int main() { HEADER *hdr; int d = NS_IN6ADDRSZ; return 0; }"
                NEED_NAMESER_COMPAT_H)
            if (NEED_NAMESER_COMPAT_H)
                set(HAVE_ASYNC_DNS true)
            else ()
                message(WARNING "Darwin compatibility check failed."
                        "Non-blocking DNS support disabled.")
                set(HAVE_ASYNC_DNS false)
                set(USE_NB_DNS false)
            endif ()
        endif ()
    endif ()
endif ()

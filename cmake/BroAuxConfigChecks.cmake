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

include(CheckNameserCompat)

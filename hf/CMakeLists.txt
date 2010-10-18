find_package(FLEX REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR}
                    ${CMAKE_CURRENT_BINARY_DIR})

########### hf target ###############

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

include(CheckPrototypeExists)

check_prototype_exists(socket "sys/socket.h" HAVE_SOCK_DECL)
if (NOT HAVE_SOCK_DECL)
    set(DO_SOCK_DECL true)
    message(STATUS "socket prototypes need declaration")
endif ()

if (USE_NB_DNS)
    include(CheckCSourceCompiles)

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

configure_file(${CMAKE_CURRENT_SOURCE_DIR}/config.h.in
               ${CMAKE_CURRENT_BINARY_DIR}/config.h)

flex_target(hfScanner hf.l ${CMAKE_CURRENT_BINARY_DIR}/hf.c)

if (USE_NB_DNS)
    set(dns_SRCS nb_dns.c nb_dns.h)
    set(hf_EXTRA_LIBS resolv)
endif ()

set(hf_SRCS
    ${FLEX_hfScanner_OUTPUTS}
    setsignal.c
    version.c
    setsignal.h
    gnuc.h
    ${dns_SRCS}
)

add_executable(hf ${hf_SRCS})

target_link_libraries(hf ${hf_EXTRA_LIBS})

########### nf target ###############

flex_target(nfScanner nf.l ${CMAKE_CURRENT_BINARY_DIR}/nf.c)

set(nf_SRCS
    ${FLEX_nfScanner_OUTPUTS}
    setsignal.c
)

add_executable(nf ${nf_SRCS})

target_link_libraries(nf)

########### pf target ###############

flex_target(pfScanner pf.l ${CMAKE_CURRENT_BINARY_DIR}/pf.c)

set(pf_SRCS
    ${FLEX_pfScanner_OUTPUTS}
    setsignal.c
)

add_executable(pf ${pf_SRCS})

target_link_libraries(pf)

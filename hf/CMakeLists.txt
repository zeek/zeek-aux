find_package(FLEX REQUIRED)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})

########### hf target ###############

flex_target(hfScanner hf.l ${CMAKE_CURRENT_BINARY_DIR}/hf.c)

set(dns_SRCS nb_dns.c nb_dns.h)

set(hf_SRCS
    ${FLEX_hfScanner_OUTPUTS}
    setsignal.c
    version.c
    setsignal.h
    gnuc.h
    ${dns_SRCS}
)

add_executable(hf ${hf_SRCS})

target_link_libraries(hf ${BIND_LIBRARY})

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

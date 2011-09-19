set(adtrace_SRCS
    adtrace.c
    ether.h
    ethertype.h
    ip.h
)

add_executable(adtrace ${adtrace_SRCS})

target_link_libraries(adtrace ${PCAP_LIBRARY})

AddAuxInstallTarget(adtrace)

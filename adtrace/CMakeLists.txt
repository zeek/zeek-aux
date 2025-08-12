find_package(PCAP REQUIRED)

add_executable(adtrace adtrace.c)
target_link_libraries(adtrace PRIVATE ${PCAP_LIBRARY})
target_include_directories(adtrace BEFORE PRIVATE ${PCAP_INCLUDE_DIR})

addauxinstalltarget(adtrace)

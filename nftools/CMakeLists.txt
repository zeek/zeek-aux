########### ftwire2bro target ###############

set(ftwire2bro_SRCS
    ftwire2bro.c
    nfcommon.h
)

add_executable(ftwire2bro ${ftwire2bro_SRCS})

target_link_libraries(ftwire2bro ${BIND_LIBRARY})

AddAuxInstallTarget(ftwire2bro)

########### nfcollector target ###############

set(nfcollector_SRCS
    nfcollector.c
    nfcommon.h
)

add_executable(nfcollector ${nfcollector_SRCS})

target_link_libraries(nfcollector)

AddAuxInstallTarget(nfcollector)

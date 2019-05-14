set(brocut_SRCS
    zeek-cut.c
)

add_executable(zeek-cut ${brocut_SRCS})

install(FILES zeek-cut.1 DESTINATION ${BRO_MAN_INSTALL_PATH}/man1)

# Install wrapper script for Bro-to-Zeek renaming.
include(InstallSymlink)
InstallSymlink("${CMAKE_INSTALL_PREFIX}/bin/zeek-wrapper" "${CMAKE_INSTALL_PREFIX}/bin/bro-cut")

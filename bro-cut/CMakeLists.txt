set(brocut_SRCS
    bro-cut.c
)

add_executable(bro-cut ${brocut_SRCS})

install(FILES bro-cut.1 DESTINATION ${BRO_MAN_INSTALL_PATH}/man1)

